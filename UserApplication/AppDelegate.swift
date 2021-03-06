//
//  AppDelegate.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorIO

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CIOAutocompleteDelegate, CIOAutocompleteDataSource {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.showAutocompleteViewControllerAsRoot()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func showAutocompleteViewControllerAsRoot() {
        // Instantiate the autocomplete controller
        let viewController = CIOAutocompleteViewController(autocompleteKey: "CD06z4gVeqSXRiDL2ZNK")

        // set the delegate in order to react to various events
        viewController.delegate = self
        
        // set the data source to customize the look and feel of the UI
        viewController.dataSource = self
        
        let bgColor = UIColor(colorLiteralRed: 67/255.0, green: 152/255.0, blue: 234/255.0, alpha: 1.0)
        
        // embed it in the navigation controller
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.barTintColor = bgColor
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        viewController.highlighter.attributesProvider = CustomAttributesProvider()
    }

    // MARK: DataSource

    func rowHeight(in autocompleteController: CIOAutocompleteViewController) -> CGFloat {
        return 35
    }

    func styleResultLabel(label: UILabel, indexPath: IndexPath, in autocompleteController: CIOAutocompleteViewController) {
        label.textColor = self.randomColor()
    }
    
    func styleResultCell(cell: UITableViewCell, indexPath: IndexPath, in autocompleteController: CIOAutocompleteViewController) {
        if indexPath.row % 2 == 0{
            cell.contentView.backgroundColor = UIColor.lightGray
        }else{
            cell.contentView.backgroundColor = UIColor.white
        }
        
    }
    
    
//
//    func fontNormal(in autocompleteController: CIOAutocompleteViewController) -> UIFont {
//        return UI
//    }

    var i = 1
    func randomColor() -> UIColor {
        let colors = [UIColor.red, .blue, .purple, .orange, .black]
        let color = colors[i%colors.count]
        i += 1
        return color
    }

    func backgroundView(in autocompleteController: CIOAutocompleteViewController) -> UIView? {
        let view = UINib(nibName: "CustomBackgroundView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CustomBackgroundView
        return view
    }

    func errorView(in autocompleteController: CIOAutocompleteViewController) -> UIView? {
        return UINib(nibName: "CustomErrorView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
    }

    func customCellNib(in autocompleteController: CIOAutocompleteViewController) -> UINib {
        return UINib(nibName: "CustomTableViewCellOne", bundle: nil)
    }

//    func customCellClass(in autocompleteController: CIOAutocompleteViewController) -> AnyClass {
//        return CustomTableViewCellTwo.self
//    }

    // no background view
    //    func backgroundView(in autocompleteController: CIOAutocompleteViewController) -> UIView? {
    //        return nil
    //    }

    // MARK: SearchBar

    func styleSearchBar(searchBar: UISearchBar, in autocompleteController: CIOAutocompleteViewController) {
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        searchBar.returnKeyType = .yahoo
    }

    // MARK: Delegate

    func autocompleteController(controller: CIOAutocompleteViewController, errorDidOccur error: Error) {

        if let err = error as? CIOError {
            switch(err) {
            case .missingAutocompleteKey:
                print("Missing autocomplete key error")
            default:
                print("Error occured: \(error.localizedDescription)")
            }
        }
    }

    func autocompleteController(controller: CIOAutocompleteViewController, didSelectResult result: CIOResult) {
        print("item selected \(result)")
    }

    func autocompleteController(controller: CIOAutocompleteViewController, didPerformSearch searchTerm: String) {
        print("Search performed for term \(searchTerm)")
    }

    func autocompleteControllerWillAppear(controller: CIOAutocompleteViewController) {
        print("Search controller will appear")
    }

    func autocompleteControllerDidLoad(controller: CIOAutocompleteViewController) {
        print("Search controller did load")
    }

//    func searchBarPlaceholder(in autocompleteController: CIOAutocompleteViewController) -> String {
//        return "Custom search placeholder"
//    }
}
