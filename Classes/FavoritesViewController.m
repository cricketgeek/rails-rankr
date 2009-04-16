//
//  FavoritesViewController.m
//  Rails Rankr
//
//  Created by Mark Jones on 4/4/09.
//  Copyright 2009 Geordie Enterprises LLC. All rights reserved.
//

#import "FavoritesViewController.h"
#import "Response.h"
#import "Connection.h"
#import "Coder.h";
#import "CoderCell.h";

@interface FavoritesViewController (Private)

- (void) loadCoders;

@end

@implementation FavoritesViewController

@synthesize favorites, tableView;

- (void) loadCoders {
  NSString *coderPath = [NSString stringWithFormat:@"%@coders/get_coders/coder%@?coders=%@",
                         [Coder getRemoteSite],
                         [Coder getRemoteProtocolExtension],
                         @"Mark-Jones,Collin-VanDyck,Nathen-Grass,Andrew-Stone,Jesse-Newland,Hank-Beaver,Fadi-Eliya,Tommy-Campbell,Zack-Adams,Jonathan-Nelson,Tim-Kadom,Sari-Connard,Desi-McAdam,Rein-Heinrichs,Tim-Pope,Stephen-Martin,Dan-Morris,Durran-Jordan,Jason-Noble,Luigi-Montanez"];
	
	//send the response
  Response *res = [Connection get:coderPath];
	self.favorites = [Coder fromJSONData:res.body];
	[tableView reloadData];
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setRowHeight:135];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadCoders];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)atableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)atableView
 numberOfRowsInSection:(NSInteger)section {
  return self.favorites.count;
}

- (UITableViewCell *)tableView:(UITableView *)atableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  CoderCell *cell = (CoderCell*)[atableView
                           dequeueReusableCellWithIdentifier:@"Coder" ];
  if(nil == cell) {
    cell = [self createCoderCellFromNib];  
  }
  Coder* coder = ((Coder *)[favorites objectAtIndex:indexPath.row]);
  cell.nameLabel.text = coder.fullName;
  cell.rankLabel.text = coder.rank;
  cell.cityLabel.text = coder.city;
  
  //cell.text = [NSString stringWithFormat:@"%@ %@",coder.rank,coder.fullName];
  return cell;
}

- (CoderCell*)createCoderCellFromNib {
  
  NSArray* nibContents = [[NSBundle mainBundle]
                          loadNibNamed:@"CoderCell" owner:self options:nil];
  NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
  CoderCell* coderCell = nil;
  NSObject* nibItem = nil;
  while ( (nibItem = [nibEnumerator nextObject]) != nil) {
    if ( [nibItem isKindOfClass: [CoderCell class]]) {
      coderCell = (CoderCell*) nibItem;
      if ([coderCell.reuseIdentifier isEqualToString: @"Coder" ])
        break; // we have a winner
      else
        coderCell = nil;
    }
  }
  return coderCell;
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


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


- (void)dealloc {
    [super dealloc];
}


@end

