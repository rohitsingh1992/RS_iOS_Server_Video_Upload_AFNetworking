//
//  ViewController.m
//  UploadVideo
//
//  Created by Rohit Singh on 24/01/16.
//  Copyright © 2016 Home. All rights reserved.
//


#import "ViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>


@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageSelected;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.progressView setProgress:0.0];
   // [self upload];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)upload:(UIImage *)image{
    
   // AFHTTPRequestOperation
    
    NSString *strServerUrl = @"http://zabius.com/uploadtest/serverupload/upload.php";
    
   NSTimeInterval name = [[NSDate date] timeIntervalSince1970];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:strServerUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        
        [formData appendPartWithFileData:imageData name:@"uploaded_file" fileName:[NSString stringWithFormat:@"%f.jpeg",name] mimeType:@"image/jpeg"];
    
    } error:nil];
    
    //[request setHTTPMethod:@"POST"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    
    

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
  
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          [self.progressView setProgress:uploadProgress.fractionCompleted];
                          
                          NSLog(@"Proggress%f",uploadProgress.fractionCompleted);
                      });
                      
                      
                      
                      
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          
                          
                          NSLog(@"%@ %@", response, responseObject);
                      }
                  }];
    
    [uploadTask resume];

}


-(void)uploadUsingURL:(NSURL *)imageString{
    
    NSString *strServerUrl = @"http://zabius.com/uploadtest/serverupload/upload.php";
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:strServerUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSTimeInterval name = [[NSDate date] timeIntervalSince1970];

        
    [formData appendPartWithFileURL:imageString name:@"uploaded_file" fileName:[NSString stringWithFormat:@"%f.mov",name] mimeType:@"video/mov" error:nil];
        
        
    } error:nil];
    
    //[request setHTTPMethod:@"POST"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                           [self.progressView setProgress:uploadProgress.fractionCompleted];
                          
                          NSLog(@"Proggress%f",uploadProgress.fractionCompleted);
                      });
                      
                      
                      
                      
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          
                          
                          NSLog(@"%@ %@", response, responseObject);
                      }
                  }];
    
    [uploadTask resume];
    
}

- (IBAction)tapSelectImage:(UIButton *)sender {
    [self selectImage:YES];
}

- (IBAction)tapSelectVideo:(UIButton *)sender {
    [self selectImage:NO];

}

-(void)selectImage:(BOOL)isImage{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    picker.allowsEditing = YES;
    
    if (isImage) {
        picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    } else{
        picker.videoMaximumDuration = 60;
        picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
    }
    
    [self presentViewController:picker animated:true completion:^{
        
    }];

}




-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.imageSelected.image = image;
    
   // NSString *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
    NSLog(@"Videos url %@",videoUrl);
  //  NSLog(@"image url %@",imageURL);

    [self dismissViewControllerAnimated:true completion:^{
        if (videoUrl) {
            [self uploadUsingURL:videoUrl];

        } else {
            [self upload:image];

        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}



@end
