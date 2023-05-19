
import UIKit

var windowScene: UIWindowScene? {
    UIApplication.shared.connectedScenes.first as? UIWindowScene
}

var firstWindow: UIWindow? {
    windowScene?.windows.first
}

var deviceSafeAreaInsets: UIEdgeInsets? {
    firstWindow?.safeAreaInsets
}
