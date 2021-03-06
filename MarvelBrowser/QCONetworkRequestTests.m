#import "QCONetworkRequest.h"

#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import <XCTest/XCTest.h>


@interface QCONetworkRequestTests : XCTestCase
@end

@implementation QCONetworkRequestTests
{
    id mockTask;
    QCONetworkRequest *sut;
}

- (void)setUp
{
    [super setUp];
    mockTask = mock([NSURLSessionTask class]);
    sut = [[QCONetworkRequest alloc] init];
}

- (void)tearDown
{
    mockTask = nil;
    sut = nil;
    [super tearDown];
}

- (void)testStartTask_ShouldTellTaskToResume
{
    [sut startTask:mockTask];
    
    [verify(mockTask) resume];
}

- (void)testStartTask_ShouldRetainGivenTask
{
    [sut startTask:mockTask];
    
    assertThat(sut.currentTask, is(sameInstance(mockTask)));
}

- (void)testStartTask_WithExistingTask_ShouldThrowInternalInconsistencyException
{
    [sut startTask:mockTask];
    
    assertThat(^{ [self->sut startTask:[[NSURLSessionTask alloc] init]]; },
            throwsException(hasProperty(@"name", NSInternalInconsistencyException)));
}

- (void)testDidComplete_WithExistingTask_ShouldReleaseTask
{
    [sut startTask:mockTask];
    
    [sut didComplete];
    
    assertThat(sut.currentTask, is(nilValue()));
}

- (void)testCancel_WithExistingTask_ShouldCancelTask
{
    [sut startTask:mockTask];
    
    [sut cancel];
    
    [verify(mockTask) cancel];
}

- (void)testDidCancel_WithExistingTask_ShouldReleaseTask
{
    [sut startTask:mockTask];
    
    [sut cancel];
    
    assertThat(sut.currentTask, is(nilValue()));
}

@end
