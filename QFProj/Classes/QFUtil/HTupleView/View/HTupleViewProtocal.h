//
//  HTupleViewProtocal.h
//  QFProj
//
//  Created by wind on 2020/2/17.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HTupleViewProtocal <UICollectionViewDelegate>
@optional

// UICollectionViewDelegate
- (BOOL)shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)didDeselectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;
- (void)didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath;

- (BOOL)shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender;
- (void)performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender;

- (nonnull UICollectionViewTransitionLayout *)transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout;

 // Focus
- (BOOL)canFocusItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context;
- (void)didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator;
- (nullable NSIndexPath *)indexPathForPreferredFocusedViewIn;

- (NSIndexPath *)targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath;

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset;

- (BOOL)shouldSpringLoadItemAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context API_AVAILABLE(ios(11.0));

- (BOOL)shouldBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath;

- (void)didBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath;

- (void)collectionViewDidEndMultipleSelectionInteraction:(UICollectionView *)collectionView;

- (nullable UIContextMenuConfiguration *)contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point API_AVAILABLE(ios(13.0));

- (nullable UITargetedPreview *)previewForHighlightingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0));

- (nullable UITargetedPreview *)previewForDismissingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0));

- (void)willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator API_AVAILABLE(ios(13.0));


// UIScrollViewDelegate

- (void)tupleScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)tupleScrollViewDidZoom:(UIScrollView *)scrollView;

- (void)tupleScrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)tupleScrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

- (void)tupleScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)tupleScrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)tupleScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)tupleScrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

- (nullable UIView *)tupleViewForZoomingInScrollView:(UIScrollView *)scrollView;
- (void)tupleScrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view;
- (void)tupleScrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale;

- (BOOL)tupleScrollViewShouldScrollToTop:(UIScrollView *)scrollView;
- (void)tupleScrollViewDidScrollToTop:(UIScrollView *)scrollView;

- (void)tupleScrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView;
@end

NS_ASSUME_NONNULL_END
