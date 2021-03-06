#import "OpenFilePlugin.h"
#import "WebKit/WebKit.h"

@interface OpenFilePlugin ()<UIDocumentInteractionControllerDelegate>
@end

static NSString *const CHANNEL_NAME = @"open_file";

@implementation OpenFilePlugin{
    FlutterResult _result;
    UIViewController *_viewController;
    UIDocumentInteractionController *_documentController;
    UIDocumentInteractionController *_interactionController;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:CHANNEL_NAME
                                     binaryMessenger:[registrar messenger]];
    UIViewController *viewController =
    [UIApplication sharedApplication].delegate.window.rootViewController;
    OpenFilePlugin* instance = [[OpenFilePlugin alloc] initWithViewController:viewController];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"open_file" isEqualToString:call.method]) {
        _result = result;
        NSString *msg = call.arguments[@"file_path"];
        NSNumber *numberWithBool = call.arguments[@"allow_to_export"];
        BOOL allowToExport = [numberWithBool boolValue];
        NSFileManager *fileManager=[NSFileManager defaultManager];
        BOOL fileExist=[fileManager fileExistsAtPath:msg];
        if(fileExist){
//            NSURL *resourceToOpen = [NSURL fileURLWithPath:msg];
            NSString *exestr = [msg pathExtension];
            _documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:msg]];
            _documentController.delegate = self;
            if([exestr isEqualToString:@"rtf"]){
                _documentController.UTI=@"public.rtf";
            }else if([exestr isEqualToString:@"txt"]){
                _documentController.UTI=@"public.plain-text";
            }else if([exestr isEqualToString:@"html"]||
                     [exestr isEqualToString:@"htm"]){
                _documentController.UTI=@"public.html";
            }else if([exestr isEqualToString:@"xml"]){
                _documentController.UTI=@"public.xml";
            }else if([exestr isEqualToString:@"tar"]){
                _documentController.UTI=@"public.tar-archive";
            }else if([exestr isEqualToString:@"gz"]||
                     [exestr isEqualToString:@"gzip"]){
                _documentController.UTI=@"org.gnu.gnu-zip-archive";
            }else if([exestr isEqualToString:@"tgz"]){
                _documentController.UTI=@"org.gnu.gnu-zip-tar-archive";
            }else if([exestr isEqualToString:@"jpg"]||
                     [exestr isEqualToString:@"jpeg"]){
                _documentController.UTI=@"public.jpeg";
            }else if([exestr isEqualToString:@"png"]){
                _documentController.UTI=@"public.png";
            }else if([exestr isEqualToString:@"avi"]){
                _documentController.UTI=@"public.avi";
            }else if([exestr isEqualToString:@"mpg"]||
                     [exestr isEqualToString:@"mpeg"]){
                _documentController.UTI=@"public.mpeg";
            }else if([exestr isEqualToString:@"mp4"]){
                _documentController.UTI=@"public.mpeg-4";
            }else if([exestr isEqualToString:@"3gpp"]||
                     [exestr isEqualToString:@"3gp"]){
                _documentController.UTI=@"public.3gpp";
            }else if([exestr isEqualToString:@"mp3"]){
                _documentController.UTI=@"public.mp3";
            }else if([exestr isEqualToString:@"zip"]){
                _documentController.UTI=@"com.pkware.zip-archive";
            }else if([exestr isEqualToString:@"gif"]){
                _documentController.UTI=@"com.compuserve.gif";
            }else if([exestr isEqualToString:@"bmp"]){
                _documentController.UTI=@"com.microsoft.bmp";
            }else if([exestr isEqualToString:@"ico"]){
                _documentController.UTI=@"com.microsoft.ico";
            }else if([exestr isEqualToString:@"doc"]){
                _documentController.UTI=@"com.microsoft.word.doc";
            }else if([exestr isEqualToString:@"xls"]){
                _documentController.UTI=@"com.microsoft.excel.xls";
            }else if([exestr isEqualToString:@"ppt"]){
                _documentController.UTI=@"com.microsoft.powerpoint.​ppt";
            }else if([exestr isEqualToString:@"wav"]){
                _documentController.UTI=@"com.microsoft.waveform-​audio";
            }else if([exestr isEqualToString:@"wm"]){
                _documentController.UTI=@"com.microsoft.windows-​media-wm";
            }else if([exestr isEqualToString:@"wmv"]){
                _documentController.UTI=@"com.microsoft.windows-​media-wmv";
            }else if([exestr isEqualToString:@"pdf"]){
                _documentController.UTI=@"com.adobe.pdf";
            }else {
                NSLog(@"doc type not supported for preview");
                NSLog(@"%@", exestr);
            }

            if(allowToExport) {
                BOOL previewSucceeded = [_documentController presentPreviewAnimated:YES];
                if(!previewSucceeded) {
                    [_documentController presentOpenInMenuFromRect:CGRectMake(500,20,100,100) inView:_viewController.view animated:YES];
                }
            } else {
                NSURL *fileURL = [NSURL fileURLWithPath:msg];
                [self loadFileWithWKWebView:fileURL];
            }
            
        }else{
            result(@"the file is not exist");
        }
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void) loadFileWithWKWebView:(NSURL*)url {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:_viewController.view.frame];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:urlRequest];
    UIViewController *webViewController = [[UIViewController alloc] init];
    [webViewController.view addSubview:webView];
    UIBarButtonItem *done =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    webViewController.navigationItem.leftBarButtonItem = done;
    webViewController.navigationItem.title = url.lastPathComponent;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    
    [_viewController presentViewController:navController animated:YES completion:nil];
}

- (void)dismiss {
    [_viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
    _result(@"done");
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return  _viewController;
}


@end
