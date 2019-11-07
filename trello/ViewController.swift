//
//  ViewController.swift
//  trello
//
//  Created by Юрий Нориков on 07.11.2019.
//  Copyright © 2019 norikoff. All rights reserved.
//

class ViewController: UIViewController, TaskCreator, UICollectionViewDelegate {
    
    /// Calculate where navigation bar ends
    var topDistance : CGFloat{
        guard let navigationController = self.navigationController, navigationController.navigationBar.isTranslucent else {
            return 0
        }
        
        let barHeight = navigationController.navigationBar.frame.height
        let statusBarHeight = UIApplication.shared.isStatusBarHidden ? 0.0 : UIApplication.shared.statusBarFrame.height
        return barHeight + statusBarHeight
    }
    
    var items = [
        [
            Task(title: "Authentication", description: "Make authentication with Apple ID"),
            Task(title: "Profile Screen", description: "Draw profile screen"),
            Task(title: "Search API", description: "Create mock for search API (needed for other task)")
        ],
        [
            Task(title: "Home Screen", description: "Home screen implementation steps: \n1. do something"),
            Task(title: "Instagram-like camera", description: "Use open-source lib to implement instagram-like camera")
        ],
        [
            Task(title: "Data Service", description: "Create service for data interaction with API"),
        ],
        [
            Task(title: "Home Screen design", description: "Make design in sketch with 4 ,main screens")
        ]
    ]
    
    let collectionView: UICollectionView = {
        let layout = TaskCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dragInteractionEnabled = true
        collectionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: "TaskCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation bar setup
        self.title = "Trello"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        // columns' title creation
        let headerView = createHeader(point: topDistance)
        
        // collection view frame setup
        let collectionViewPoint = topDistance + headerView.frame.height
        collectionView.frame = CGRect(x: 0, y: collectionViewPoint, width: view.frame.width, height: view.frame.height - collectionViewPoint)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        view.addSubview(collectionView)
        view.addSubview(headerView)
    }
    
    func createHeader(point safeAreaPoint: CGFloat) -> UIStackView {
        let headerView = UIStackView(frame: CGRect(x: 0, y: safeAreaPoint, width: view.frame.width, height: 32))
        headerView.axis = .horizontal
        headerView.distribution = .fillEqually
        headerView.alignment = .center
        headerView.addBackground(color: .cyan)
        
        let toDoLabel = UILabel()
        toDoLabel.textAlignment = .center
        toDoLabel.text = "To Do"
        
        let inProgressLabel = UILabel()
        inProgressLabel.textAlignment = .center
        inProgressLabel.text = "In Progress"
        
        let inReviewLabel = UILabel()
        inReviewLabel.textAlignment = .center
        inReviewLabel.text = "In Review"
        
        let doneLabel = UILabel()
        doneLabel.textAlignment = .center
        doneLabel.text = "Done"
        
        headerView.addArrangedSubview(toDoLabel)
        headerView.addArrangedSubview(inProgressLabel)
        headerView.addArrangedSubview(inReviewLabel)
        headerView.addArrangedSubview(doneLabel)
        
        return headerView
    }
    
    @objc func addButtonTapped() {
        let popUpView = TaskCreatorImpl(frame: view.frame)
        
        popUpView.frame = view.frame
        popUpView.delegate = self
        popUpView.makeViewVisible()
        
        view.addSubview(popUpView)
        
        self.navigationItem.rightBarButtonItem = nil
    }
    
    /// Add new task to "To Do" column - ISStaskCreationViewProtocol implementation
    ///
    /// - Parameters:
    ///   - title: task title
    ///   - desc: task description
    func taskDidCreated(withTitle title: String, desc: String) {
        items[0].append(Task(title: title, description: desc))
        collectionView.reloadData()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    /// When view is removed without task creation we need to add bar button back
    func taskCreationDidCanceled() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            collectionView.performBatchUpdates({
                let element = self.items[sourceIndexPath.section].remove(at: sourceIndexPath.row)
                self.items[destinationIndexPath.section].insert(element, at: destinationIndexPath.row)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
                collectionView.reloadData()
            })
            coordinator.drop(items.first!.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCell", for: indexPath) as? TaskCollectionViewCell {
            cell.setupCell(with: items[indexPath.section][indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension ViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = items[indexPath.section][indexPath.row].title
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        
        return [dragItem]
    }
    
}

extension ViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
    {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        if collectionView.hasActiveDrag
        {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        else
        {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation
        {
        case .move:
            self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
            break
        default:
            return
        }
    }
    
}

