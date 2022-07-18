//
//  ShowViewController.m
//  iOSDeviceInfo
//
//  Created by Dio Brand on 2022/7/15.
//

#import "ShowViewController.h"

@interface ShowViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *identifier;
}
@property(weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"显示信息";
    identifier  = @"mycell";
//    self.dataArray = [[NSMutableArray alloc] init];
//    for (int i = 0; i < 20; i++) {
//        NSString *item = [NSString stringWithFormat:@"index = %d",i];
//        [self.dataArray addObject:item];
//    }
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self.myTableView registerClass:[UITableViewCell classForCoder] forCellReuseIdentifier:identifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSString *tmp = [self.dataArray objectAtIndex:indexPath.row];
    [cell.textLabel setText: tmp];
    cell.textLabel.numberOfLines = 9999;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
