//
//  MyTableViewController.m
//  CoreDataTutorial
//
//  Created by Eva Puskas on 2014. 11. 16..
//  Copyright (c) 2014. Pepzen Ltd. All rights reserved.
//

#import "MyTableViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "Type.h"
#import "ViewController.h"
#import "Hobby.h"

@interface MyTableViewController ()

@end

@implementation MyTableViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize myArray, selecteduser;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    _managedObjectContext = [appDelegate managedObjectContext];
    
    self.myArray =[[appDelegate getAllUserRecords]mutableCopy];


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return myArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    NSString *attributeName = @"userName";
    NSString *attributeValue = @"user";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", attributeName, attributeValue];
    [myArray filteredArrayUsingPredicate:predicate];



     User *user1=[self.myArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", user1.userName];
    
    NSArray *hobbiesArray = [user1.hobbiesofuser allObjects];
    
    Hobby *hobby1 = [hobbiesArray firstObject];

    
    // detect typeName with "typeofuser" relationship
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", user1.typeofuser.typeName, hobby1.hobbyName];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selecteduser = [self.myArray objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"selectuser" sender:self];
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"selectuser"]) {
        
        ViewController * detailViewController = (ViewController *)segue.destinationViewController;
        detailViewController.selecteduser = selecteduser;
    }
    

}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.tableView beginUpdates];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        _managedObjectContext = [appDelegate managedObjectContext];
        
        // delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //delete data from database
        
        [self.managedObjectContext deleteObject:[self.myArray objectAtIndex:indexPath.row]];
        
        NSError *error;
        
        if (![self.managedObjectContext save:&error]) {
            
            NSLog(@"Whoops, couldn't save:%@", [error localizedDescription]);
        }
        self.myArray = [appDelegate getAllUserRecords];
        
        [self.tableView endUpdates];
        
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

/*

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
