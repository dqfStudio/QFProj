//
//  HTupleView+HProtocal.m
//  QFProj
//
//  Created by wind on 2020/2/17.
//  Copyright © 2020 dqfStudio. All rights reserved.
//

#import "HTupleView.h"

@implementation HTupleView (HProtocal)

// UICollectionViewDataSource
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"canMoveItemAtIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    NSString *prefix = [self tuplePrefix];
    SEL selector = NSSelectorFromString(@"moveItemAtIndexPath:toIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&sourceIndexPath, &destinationIndexPath];
    }
}

- (nullable NSArray<NSString *> *)indexTitlesForCollectionView:(UICollectionView *)collectionView {
    NSString *prefix = [self tuplePrefix];
    SEL selector = NSSelectorFromString(@"indexTitlesForCollectionView");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix];
    }
    return nil;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSString *prefix = [self tuplePrefix];
    SEL selector = NSSelectorFromString(@"indexPathForIndexTitle:atIndex:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix];
    }
    return nil;
}

// UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"shouldHighlightItemAtIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"didHighlightItemAtIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"didUnhighlightItemAtIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"shouldSelectItemAtIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"shouldDeselectItemAtIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"didDeselectItemAtIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"willDisplaySupplementaryView:forElementKind:atIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&view, &elementKind ,&indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"didEndDisplayingCell:forItemAtIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&cell ,&indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&view, &elementKind ,&indexPath];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"shouldShowMenuForItemAtIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"canPerformAction:forItemAtIndexPath:withSender:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&action, &indexPath, &sender] boolValue];
    }
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"performAction:forItemAtIndexPath:withSender:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&action, &indexPath ,&sender];
    }
}

- (nonnull UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
    NSString *prefix = [self tuplePrefix];
    SEL selector = NSSelectorFromString(@"transitionLayoutForOldLayout:newLayout:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tupleDelegate performSelector:selector withMethodArgments:&fromLayout, &toLayout];
    }
    return UICollectionViewTransitionLayout.new;
}

// Focus
- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"canFocusItemAtIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context {
    NSString *prefix = [self tuplePrefix];
    SEL selector = NSSelectorFromString(@"shouldUpdateFocusInContext:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:selector withMethodArgments:&context] boolValue];
    }
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    NSString *prefix = [self tuplePrefix];
    SEL selector = NSSelectorFromString(@"didUpdateFocusInContext:withAnimationCoordinator:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withMethodArgments:&context, &coordinator];
    }
}
- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView {
    NSString *prefix = [self tuplePrefix];
    SEL selector = NSSelectorFromString(@"indexPathForPreferredFocusedViewInCollectionView");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [(NSObject *)self.tupleDelegate performSelector:selector];
        #pragma clang diagnostic pop
    }
    return nil;
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    NSString *prefix = [self tuplePrefix];
    SEL selector = NSSelectorFromString(@"targetIndexPathForMoveFromItemAtIndexPath:toProposedIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tupleDelegate performSelector:selector withMethodArgments:&originalIndexPath, &proposedIndexPath];
    }
    return originalIndexPath;
}

- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    NSString *prefix = [self tuplePrefix];
    SEL selector = NSSelectorFromString(@"targetIndexPathForMoveFromItemAtIndexPath:toProposedIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:selector withMethodArgments:&proposedContentOffset] CGPointValue];
    }
    return CGPointZero;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSpringLoadItemAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context API_AVAILABLE(ios(11.0)) {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"shouldSpringLoadItemAtIndexPath:withContext:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath, &context] boolValue];
    }
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"shouldBeginMultipleSelectionInteractionAtIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath] boolValue];
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath {
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"didBeginMultipleSelectionInteractionAtIndexPath:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath];
    }
}

- (void)collectionViewDidEndMultipleSelectionInteraction:(UICollectionView *)collectionView {
    NSString *prefix = [self tuplePrefix];
    SEL selector = NSSelectorFromString(@"collectionViewDidEndMultipleSelectionInteraction");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tupleDelegate performSelector:selector];
        #pragma clang diagnostic pop
    }
}

- (nullable UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point API_AVAILABLE(ios(13.0)){
    NSString *prefix = [self tuplePrefixWithSection:indexPath.section];
    SEL selector = NSSelectorFromString(@"contextMenuConfigurationForItemAtIndexPath:point:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tupleDelegate performSelector:selector withPre:prefix withMethodArgments:&indexPath, &point];
    }
    return nil;
}

- (nullable UITargetedPreview *)collectionView:(UICollectionView *)collectionView previewForHighlightingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0)) {
    NSString *prefix = [self tuplePrefix];
    SEL selector = NSSelectorFromString(@"previewForHighlightingContextMenuWithConfiguration:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tupleDelegate performSelector:selector withMethodArgments:&configuration];
    }
    return nil;
}

- (nullable UITargetedPreview *)collectionView:(UICollectionView *)collectionView previewForDismissingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0)) {
    NSString *prefix = [self tuplePrefix];
    SEL selector = NSSelectorFromString(@"previewForDismissingContextMenuWithConfiguration:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tupleDelegate performSelector:selector withMethodArgments:&configuration];
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator API_AVAILABLE(ios(13.0)) {
    NSString *prefix = [self tuplePrefix];
    SEL selector = NSSelectorFromString(@"willPerformPreviewActionForMenuWithConfiguration:animator:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withMethodArgments:&configuration, &animator];
    }
}


// UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidScroll:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tupleDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidZoom:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tupleDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleScrollViewWillBeginDragging:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tupleDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleScrollViewWillEndDragging:withVelocity:targetContentOffset:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withMethodArgments:&scrollView, &velocity, &targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleScrollViewWillEndDragging:willDecelerate:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withMethodArgments:&scrollView, &decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleScrollViewWillBeginDecelerating:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tupleDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidEndDecelerating:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tupleDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidEndScrollingAnimation:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tupleDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleViewForZoomingInScrollView:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [(NSObject *)self.tupleDelegate performSelector:selector withMethodArgments:&scrollView];
    }
    return nil;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidScrollToTop:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tupleDelegate performSelector:selector withObject:scrollView withObject:view];
        #pragma clang diagnostic pop
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidEndZooming:withView:atScale:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        [(NSObject *)self.tupleDelegate performSelector:selector withMethodArgments:&scrollView, &view, &scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleScrollViewShouldScrollToTop:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        return [[(NSObject *)self.tupleDelegate performSelector:selector withMethodArgments:&scrollView] boolValue];
    }
    return YES;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidScrollToTop:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tupleDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    NSString *prefix = [self tupleScrollSplitPrefix];
    SEL selector = NSSelectorFromString(@"tupleScrollViewDidChangeAdjustedContentInset:");
    if ([(NSObject *)self.tupleDelegate respondsToSelector:selector withPre:prefix]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(NSObject *)self.tupleDelegate performSelector:selector withObject:scrollView];
        #pragma clang diagnostic pop
    }
}

@end
