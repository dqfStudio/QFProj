//
//  HTupleView+HProtocal.m
//  QFProj
//
//  Created by wind on 2020/2/17.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HTupleView.h"

@implementation HTupleView (HProtocal)

/*
 *下列协议方法根据需要打开，并将对应的协议头方法添加到HTupleViewDelegate中
 */

// UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"shouldHighlightItemAtIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"didHighlightItemAtIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"didUnhighlightItemAtIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"shouldSelectItemAtIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"shouldDeselectItemAtIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"didDeselectItemAtIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"willDisplaySupplementaryView:forElementKind:atIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&view, &elementKind ,&indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"didEndDisplayingCell:forItemAtIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&cell ,&indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&view, &elementKind ,&indexPath];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"shouldShowMenuForItemAtIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"canPerformAction:forItemAtIndexPath:withSender:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&action, &indexPath, &sender] boolValue];
    }
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"performAction:forItemAtIndexPath:withSender:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&action, &indexPath ,&sender];
    }
}

- (nonnull UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
    SEL selector = NSSelectorFromString(@"transitionLayoutForOldLayout:newLayout:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        return [(NSObject *)self.delegate performSelector:selector withMethodArgments:&fromLayout, &toLayout];
    }
    return UICollectionViewTransitionLayout.new;
}

// Focus
- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"canFocusItemAtIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context {
    SEL selector = NSSelectorFromString(@"shouldUpdateFocusInContext:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        return [[(NSObject *)self.delegate performSelector:selector withMethodArgments:&context] boolValue];
    }
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    SEL selector = NSSelectorFromString(@"didUpdateFocusInContext:withAnimationCoordinator:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        [(NSObject *)self.delegate performSelector:selector withMethodArgments:&context, &coordinator];
    }
}
- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView {
    SEL selector = NSSelectorFromString(@"indexPathForPreferredFocusedViewInCollectionView");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [(NSObject *)self.delegate performSelector:selector];
        #pragma clang diagnostic pop
    }
    return nil;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    SEL selector = NSSelectorFromString(@"targetIndexPathForMoveFromItemAtIndexPath:toProposedIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        return [(NSObject *)self.delegate performSelector:selector withMethodArgments:&originalIndexPath, &proposedIndexPath];
    }
    return originalIndexPath;
}

- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    SEL selector = NSSelectorFromString(@"targetIndexPathForMoveFromItemAtIndexPath:toProposedIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        return [[(NSObject *)self.delegate performSelector:selector withMethodArgments:&proposedContentOffset] CGPointValue];
    }
    return CGPointZero;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSpringLoadItemAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context API_AVAILABLE(ios(11.0)) {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"shouldSpringLoadItemAtIndexPath:withContext:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&indexPath, &context] boolValue];
    }
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"shouldBeginMultipleSelectionInteractionAtIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"didBeginMultipleSelectionInteractionAtIndexPath:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}

- (void)collectionViewDidEndMultipleSelectionInteraction:(UICollectionView *)collectionView {
    SEL selector = NSSelectorFromString(@"collectionViewDidEndMultipleSelectionInteraction");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.delegate performSelector:selector];
        #pragma clang diagnostic pop
    }
}

- (nullable UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point API_AVAILABLE(ios(13.0)){
    NSInteger section = indexPath.section;
    NSString *prefix = [self performSelector:NSSelectorFromString(@"prefixWithSection:") withMethodArgments:&section];
    SEL selector = NSSelectorFromString(@"contextMenuConfigurationForItemAtIndexPath:point:");
    if ([(NSObject *)self.delegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.delegate performSelector:selector withPre:prefix withMethodArgments:&indexPath, &point];
    }
    return nil;
}

- (nullable UITargetedPreview *)collectionView:(UICollectionView *)collectionView previewForHighlightingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0)) {
    SEL selector = NSSelectorFromString(@"previewForHighlightingContextMenuWithConfiguration:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        return [(NSObject *)self.delegate performSelector:selector withMethodArgments:&configuration];
    }
    return nil;
}

- (nullable UITargetedPreview *)collectionView:(UICollectionView *)collectionView previewForDismissingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0)) {
    SEL selector = NSSelectorFromString(@"previewForDismissingContextMenuWithConfiguration:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        return [(NSObject *)self.delegate performSelector:selector withMethodArgments:&configuration];
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator API_AVAILABLE(ios(13.0)) {
    SEL selector = NSSelectorFromString(@"willPerformPreviewActionForMenuWithConfiguration:animator:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        [(NSObject *)self.delegate performSelector:selector withMethodArgments:&configuration, &animator];
    }
}


// UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidScroll:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.delegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidZoom:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.delegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    SEL selector = NSSelectorFromString(@"tupleScrollViewWillBeginDragging:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.delegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    SEL selector = NSSelectorFromString(@"tupleScrollViewWillEndDragging:withVelocity:targetContentOffset:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        [(NSObject *)self.delegate performSelector:selector withMethodArgments:&scrollView, &velocity, &targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    SEL selector = NSSelectorFromString(@"tupleScrollViewWillEndDragging:willDecelerate:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        [(NSObject *)self.delegate performSelector:selector withMethodArgments:&scrollView, &decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    SEL selector = NSSelectorFromString(@"tupleScrollViewWillBeginDecelerating:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.delegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidEndDecelerating:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.delegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidEndScrollingAnimation:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.delegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    SEL selector = NSSelectorFromString(@"tupleViewForZoomingInScrollView:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        return [(NSObject *)self.delegate performSelector:selector withMethodArgments:&scrollView];
    }
    return nil;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidScrollToTop:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.delegate performSelector:selector withObject:scrollView withObject:view];
        #pragma clang diagnostic pop
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidEndZooming:withView:atScale:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        [(NSObject *)self.delegate performSelector:selector withMethodArgments:&scrollView, &view, &scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    SEL selector = NSSelectorFromString(@"tupleScrollViewShouldScrollToTop:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        return [[(NSObject *)self.delegate performSelector:selector withMethodArgments:&scrollView] boolValue];
    }
    return YES;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidScrollToTop:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.delegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidChangeAdjustedContentInset:");
    if ([(NSObject *)self.delegate respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.delegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

@end
