//
//  QFWeakDefine.h
//  TableModel
//
//  Created by dqf on 2017/7/13.
//  Copyright © 2017年 migu. All rights reserved.
//

#ifndef QFWeakDefine_h
#define QFWeakDefine_h

#define ws weakify(self)
#define ss strongify(self)

#ifndef weakify
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#endif

#ifndef strongify
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#endif

#if DEBUG
#define ext_keywordify                                                                             \
    autoreleasepool {                                                                              \
    }
#else
#define ext_keywordify                                                                             \
    try {                                                                                          \
    } @catch (...) {                                                                               \
    }
#endif

#endif
