//
//  ViewController.swift
//  SACPublisher
//
//  Created by Emiaostein on 17/02/2017.
//  Copyright © 2017 botai. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire
import Zip

extension String {
    /*
     "InputIPTitle" = "請輸入IP地址";
     "Cancel" = "取消";
     "Done" = "確定";
     "Delete" = "刪除";
     "DeleteTitle" = "是否確定刪除所選對象？";
     "Untitled" = "未命名";
     */
    static var cancel: String { return NSLocalizedString("Cancel", comment: "")}
    static var done: String { return NSLocalizedString("Done", comment: "")}
    static var delete: String { return NSLocalizedString("Delete", comment: "")}
    static var untitled: String { return NSLocalizedString("Untitled", comment: "")}
    static var inputIPTitle: String { return NSLocalizedString("InputIPTitle", comment: "")}
    static var deleteTitle: String { return NSLocalizedString("DeleteTitle", comment: "")}
}

class NavigationViewController: UINavigationController {
    
    //MARK: Rototation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {return .portrait}
}

class ViewController: UIViewController {

    @IBOutlet weak var editItem: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate let manager = BookManager()
    fileprivate let maker = appMaker()
    
//    override var prefersStatusBarHidden: Bool {return true}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.addDemoBook()
        
        manager.actionHandler = {[weak self] action in
            guard let sf = self else { return }
            switch action {
            case .insert(let at):
                sf.collectionView.insertItems(at: [IndexPath(item: at, section: 0)])
            case .delete(let at):
                sf.collectionView.deleteItems(at: [IndexPath(item: at, section: 0)])
            case .update(let at):
                sf.collectionView.reloadItems(at: [IndexPath(item: at, section: 0)])
            default:
                ()
            }
        }
    }

    @IBAction func addClick(_ sender: Any) {
        beganInputIP()
    }
    
    @IBAction func editClick(_ sender: Any) {
        editOnOff()
    }
    
    private func editOnOff() {
        isEditing = !isEditing
        editItem.tintColor = isEditing ? UIColor(red: 0, green: 0.5, blue: 1.0, alpha: 1) : UIColor.white
        collectionView.reloadData()
    }
    
    private func beganInputIP() {
        let doneStr = String.done
        let cancelStr = String.cancel
        let title = String.inputIPTitle
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { (field) in
            field.text = UserDefaults.IP
        }
        let field = alert.textFields?.first!
        let cancel = UIAlertAction(title: cancelStr, style: .cancel, handler: nil)
        let done = UIAlertAction(title: doneStr, style: .default) {[weak self] (action) in
            guard let sf = self, let t = field?.text else {return}
            if sf.beganDownload(from: t) {
               UserDefaults.IP = t
            }
        }
        
        alert.addAction(done)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func beganDownload(from IP: String) -> Bool {
        guard !IP.isEmpty else { return false }
        return manager.download(fromIP: IP)
    }
    
    fileprivate func beganDelete(at i: Int) {
        let deleteStr = String.delete
        let cancelStr = String.cancel
        let title = String.deleteTitle
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: cancelStr, style: .cancel, handler: nil)
        let delete = UIAlertAction(title: deleteStr, style: .destructive) {[weak self] (action) in
            self?.manager.delete(at: i)
        }
        
        alert.addAction(delete)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func redownload(at i: Int) {
        if let IP = manager.book(at: i)?.IP {
            manager.delete(at: i)
            manager.download(fromIP: IP)
        }
    }
    
    fileprivate func openBook(at url: URL) {
        maker.openBook(withRootViewController: self,
                       bookDirectoryPath: url.path,
                       theDelegate: nil,
                       hiddenBackIcon: false,
                       hiddenShareIcon: true)
    }
    
}

//MARK: CollectonView DataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if let cell = cell as? ShelfCell, let book = manager.book(at: indexPath.item), let state = manager.state(at: indexPath.item) {
            cell.titleText = book.displayName
            cell.coverImg = book.coverImg
            cell.editing = isEditing
            switch state {
            case .done: cell.state = .success
            case .failture: cell.state = .failture
            case .downloading(_): cell.state = .processing
            }
            
            cell.deleteHander = { [weak self, weak cell] in
                guard let i = self?.collectionView.indexPath(for: cell!)?.item else { return }
                self?.beganDelete(at: i)
            }
            cell.redownloadHandler = { [weak self, weak cell] in
                guard let i = self?.collectionView.indexPath(for: cell!)?.item else { return }
                self?.redownload(at: i)
            }
            book.stateChangedHandler = {[weak self, weak cell] state in
                guard let sf = self, let _ = self?.collectionView.indexPath(for: cell!)?.item else { return }
                cell?.editing = sf.isEditing
                switch state {
                case .done:
                    cell?.state = .success
                case .downloading(_):
                    if cell?.state != .processing {
                        cell?.state = .processing
                    }
                case .failture:
                    cell?.state = .failture
                }
            }
        }
        
        return cell
    }
}

//MARK: CollectonView Delegate
extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let book = manager.book(at: indexPath.item) {
            openBook(at: book.bookDirUrl)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let book = manager.book(at: indexPath.item) {
            book.stateChangedHandler = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let state = manager.state(at: indexPath.item), case BookModel.State.done = state {
            return true
        } else {
            return false
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 112, height: 173)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 4, 0, 4)
    }
}

//MARK: ----- Book Manager -----

class BookModel: NSObject, NSCoding {
    
    enum State: String {
        case done, downloading, failture
        
        var archiveredState: State {
            if self != .done {
                return .failture
            } else {
                return self
            }
        }
    }
    
    var IP: String
    var ID: String
    var isDemo = false
    var name: String = String.untitled
    var stateChangedHandler: ((State) -> ())?
    var displayName: String {return name}
    var bookDirUrl: URL {
        return !isDemo ?
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(ID, isDirectory: true).appendingPathComponent("book", isDirectory: true)
            : Bundle.main.resourceURL!.appendingPathComponent(name, isDirectory: true)}
    var coverImg: UIImage {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let bookDir = documentsURL.appendingPathComponent(ID, isDirectory: true)
        let cover = bookDir.appendingPathComponent("cover").appendingPathExtension("png")
        if let cache = coverCache { return cache }
        if let image = UIImage(contentsOfFile: cover.path) { coverCache = image }
        return coverCache ?? #imageLiteral(resourceName: "default-cover")
    }
    private var coverCache: UIImage?
    
    init(IP: String) {
        self.IP = IP
        self.ID = UUID().uuidString
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(IP, forKey: "downloadIP")
        aCoder.encode(ID, forKey: "ID")
        aCoder.encode(name, forKey: "name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.IP = aDecoder.decodeObject(forKey: "downloadIP") as! String
        self.ID = aDecoder.decodeObject(forKey: "ID") as! String
        self.name = aDecoder.decodeObject(forKey: "name") as! String
    }
}



class BookManager {
    
    enum UrlType: String {
        case cover = "/publish/book/file.hl?bookID=1000&fileName=cover.png"
        case book = "/publish/book/file.hl?bookID=1000&fileName=book.zip"
        case bookName = "/publish/book/file.hl?bookID=1000&fileName=bookName.txt"
        
        func url(from IP: String) -> URL? {
            let str = "http://\(IP):9426\(self.rawValue)"
            return URL(string: str)
        }
    }
    
    enum ActionType {
        case insert(Int), delete(Int), update(Int), move(from: Int, to: Int)
    }
    
    var actionHandler: ((ActionType)->())?
    var count: Int { loaded ? () : load(); return books.count }
    
    private var loaded = false
    private var books = [BookModel]()
    private var bookStates: [String: BookModel.State] = [:]
    
    func addDemoBook() {
        let models = BookModel.demoBooks
        if (models.count <= 0) {
            return;
        }
        books.insert(contentsOf: models, at: 0)
        models.forEach{ bookStates[$0.ID] = BookModel.State.done }
    }
    
    @discardableResult
    func download(fromIP IP: String) -> Bool {
        let coverUrl = UrlType.cover.url(from: IP)
        let bookUrl = UrlType.book.url(from: IP)
        let nameUrl = UrlType.bookName.url(from: IP)
        
        guard let bookurl = bookUrl else { return false }
        
        let model = BookModel(IP: IP)
        let ID = model.ID
        books.insert(model, at: 0)
        bookStates[model.ID] = BookModel.State.downloading
        actionHandler?(.insert(0))
        save()
        
        let bookPromise = download(book: bookurl, ID: ID)
        let _ = bookPromise.then {[weak self] (success) -> (Promise<Bool>, Promise<Bool>) in
            guard let sf = self else {fatalError()}
            return (Promise(value: success), sf.download(cover: coverUrl, ID: ID))
            
        }.then { [weak self] (bookSuccess, coverSuccess) -> (Promise<Bool>, Promise<String?>) in
            guard let sf = self else {fatalError()}
            return (Promise(value: bookSuccess), sf.download(bookName: nameUrl, ID: ID))
            
        }.then {[weak self, weak model] (bookSuccess, name) -> Bool in
            guard let sf = self, let m = model, let i = self?.books.index(where: {$0.ID == m.ID}) else {return false}
            if bookSuccess {
                sf.bookStates[ID] = .done
            } else {
                sf.bookStates[ID] = .failture
            }
            if let name = name {
                m.name = name
            }
            sf.actionHandler?(.update(i))
            sf.save()
            return true
        }
        
        return true
    }
    
    func delete(at i: Int) {
        guard i < books.count else { return }
        let model = books.remove(at: i)
        bookStates[model.ID] = nil
        actionHandler?(.delete(i))
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(model.ID, isDirectory: true)
        try? FileManager.default.removeItem(at: fileURL)
        save()
    }
    
    private func save() {
        let listUrl = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!.appendingPathComponent("booklist")
        let stateUrl = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!.appendingPathComponent("bookstate")
        let bookListSuccess = NSKeyedArchiver.archiveRootObject(books, toFile: listUrl.path)
        let bookStateSuccess = NSKeyedArchiver.archiveRootObject(bookStates.map{[$0.key: $0.value.archiveredState.rawValue]}, toFile: stateUrl.path)
        print(bookListSuccess)
        print(bookStateSuccess)
    }
    
    func state(at i: Int) -> BookModel.State? {
        guard i < books.count else { return nil }
        let state = bookStates[books[i].ID]
        return state
    }
    
    func book(at i: Int) -> BookModel? {
        guard i < books.count else { return nil }
        return books[i]
    }
    
    private func load() {
        let listUrl = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!.appendingPathComponent("booklist")
        let stateUrl = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!.appendingPathComponent("bookstate")
        if let books = NSKeyedUnarchiver.unarchiveObject(withFile: listUrl.path) as? [BookModel], let states = NSKeyedUnarchiver.unarchiveObject(withFile: stateUrl.path) as? [[String: String]]  {
            self.books.append(contentsOf: books)
            for item in states { bookStates[item.keys.first!] = BookModel.State(rawValue: item.values.first!) }
        }
        loaded = true
    }
    
    private func download(book bookUrl: URL, ID: String) -> Promise<Bool> {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let bookDir = documentsURL.appendingPathComponent(ID, isDirectory: true)
        let bookZip = bookDir.appendingPathComponent("book").appendingPathExtension("zip")
        return Promise(resolvers: { (fullfil, reject) in
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (bookZip, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            Alamofire.download(bookUrl, to: destination).response { response in
                if response.error == nil, let zipUrl = response.destinationURL {
                    do {
                        try Zip.unzipFile(zipUrl, destination: bookDir, overwrite: true, password: nil, progress: nil)
                        fullfil(true)
                    } catch {
                        fullfil(false)
                    }
                } else {
                    fullfil(false)
                }
            }
        })
    }
    
    private func download(cover coverUrl: URL?, ID: String) -> Promise<Bool> {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let bookDir = documentsURL.appendingPathComponent(ID, isDirectory: true)
        let cover = bookDir.appendingPathComponent("cover").appendingPathExtension("png")
        return Promise(resolvers: { (fullFill, reject) in
            guard let url = coverUrl else { fullFill(false); return }
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (cover, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            Alamofire.download(url, to: destination).response { response in
                if response.error == nil {
                    fullFill(true)
                } else {
                    fullFill(false)
                }
            }
        })
    }
    
    private func download(bookName nameUrl: URL?, ID: String) -> Promise<String?> {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let bookDir = documentsURL.appendingPathComponent(ID, isDirectory: true)
        let name = bookDir.appendingPathComponent("name").appendingPathExtension("txt")
        return Promise(resolvers: { (fullFill, reject) in
            guard let url = nameUrl else { fullFill(nil); return }
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                return (name, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            Alamofire.download(url, to: destination).response { response in
                do {
                    if response.error == nil, let nameFileUrl = response.destinationURL {
                         let string = try String(contentsOf: nameFileUrl)
                        fullFill(string)
                        
                    } else {
                        fullFill(nil)
                    }
                } catch {
                    fullFill(nil)
                }
            }
        })
    }
}


//MARK: ----- Cell -----
class ShelfCell: UICollectionViewCell {
    
    enum State {
        case success, processing, failture
    }
    
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var redownloadButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var editing = false
    var deleteHander: (()->())?
    var redownloadHandler: (()->())?
    
    var titleText: String {
        get { return title.text ?? "Untitled" }
        set { title.text = newValue }
    }
    
    var coverImg: UIImage? {
        get { return cover.image }
        set {cover.image = newValue}
    }
    
    var state: State = .failture {
        didSet {
            switch state {
            case .success:
                cover.isHighlighted = false
                redownloadButton.isHidden = true
                activityView.stopAnimating()
                deleteButton.isHidden = !editing
            case .processing:
                cover.isHighlighted = true
                redownloadButton.isHidden = true
                activityView.startAnimating()
                deleteButton.isHidden = !editing
            case .failture:
                cover.isHighlighted = true
                redownloadButton.isHidden = false
                activityView.stopAnimating()
                deleteButton.isHidden = !editing
            }
        }
    }
    
    @IBAction func deleteClick(_ sender: Any) {
        deleteHander?()
    }
    @IBAction func redownloadClick(_ sender: Any) {
        redownloadHandler?()
    }
}

//MARK: ----- Storage -----
extension UserDefaults {
    struct DefaultKeys {
        enum Keys: String {
            case IP = "com.u-smart.input.ip"
        }
    }
    static var IP: String? {
        get { return UserDefaults.standard.value(forKey: DefaultKeys.Keys.IP.rawValue) as? String ?? "192.168." }
        set { UserDefaults.standard.setValue(newValue, forKey: DefaultKeys.Keys.IP.rawValue)}
    }
}

