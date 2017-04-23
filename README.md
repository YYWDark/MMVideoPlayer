本篇文章从播放一个本地代码开始吧：
```
NSArray *keys = @[
@"tracks",
@"duration",
@"commonMetadata",
@"availableMediaCharacteristicsWithMediaSelectionOptions"
];
NSURL *assrtUrl = [[NSBundle mainBundle] URLForResource:@"locationVideo" withExtension:@"mp4"];
AVAsset *asset = [AVAsset assetWithURL:assrtUrl];
AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset automaticallyLoadedAssetKeys:keys];
AVPlayer  *player = [AVPlayer playerWithPlayerItem:playerItem];
AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
playerLayer.frame=CGRectMake(0, 100, self.view.frame.size.width, 300);
[self.view.layer addSublayer:playerLayer];
[player play];
```
当你把这段代码copy到一个新建的ViewController,Run你就会发现一个视频开始播放了。兴奋之余，你发现你除了默默的看它播放好像啥也干不了。接下来我们来认识下那些陌生的类：`AVPlayer`，`AVPlayerItem`，`AVAsset`，`AVPlayerLayer`。然后再看看我们还能干点啥。

####AVPlayer
`AVPlayer`类是用来管理媒体资源播放的控制器。它提供了播放，暂停，改变播放速率等接口。你可以使用它来播放本地视频和网络视频。
`AVPlayerItem`类是这个播放协作体里面非常重要的一环，如果你细心的话你会现在`AVPlayer`对象的初始化方法大多都会接受一个`AVPlayerItem`对象的参数。`AVPlayerItem`为`AVPlayer`提供媒体资源的总时长，当前播放的时间进度，当前的缓存总进度等接口，你可以利用利用这些接口去更新你的UI界面。
`AVAsset`


我们知道调用[player play]方法后视频不一定马上播放，但是我们想知道视频开始播放的准确时间，因为我们急着去更新我们界面播放按钮的图标了。我们可以通过KVO来观察`AVPlayerItem`对象的@"status"属性的状态
```
[playerItem addObserver:self
forKeyPath:@"status"
options:options
context:&PlayerItemContext];

- (void)observeValueForKeyPath:(NSString *)keyPath
ofObject:(id)object
change:(NSDictionary<NSString *,id> *)change
context:(void *)context {
// Only handle observations for the PlayerItemContext
if (context != &PlayerItemContext) {
[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
return;
}

if ([keyPath isEqualToString:@"status"]) {
AVPlayerItemStatus status = AVPlayerItemStatusUnknown;
// Get the status change from the change dictionary
NSNumber *statusNumber = change[NSKeyValueChangeNewKey];
if ([statusNumber isKindOfClass:[NSNumber class]]) {
status = statusNumber.integerValue;
}
// Switch over the status
switch (status) {
case AVPlayerItemStatusReadyToPlay:
// Ready to Play
break;
case AVPlayerItemStatusFailed:
// Failed. Examine AVPlayerItem.error
break;
case AVPlayerItemStatusUnknown:
// Not ready
break;
}
}
}
```
当回调的`AVPlayerItemStatus`状态为`AVPlayerItemStatusReadyToPlay`意味着`player item`准备被播放了。


