## Basic Usage

1. Import

```
import DesignSystem
```

2. Extend your view controller:

```
extension VIDHistoryViewController: StateViewPresentable {

    /// Required
    func hasContent() -> Bool {
        // return true if there is any data has been loaded 
    }
    
    /// Required
    func loadingView() -> UIView? {
        let loadingView = ... // custom loading view
        return loadingView
    }
    
    /// Optional
    /// Custom the data displayed on Empty View, action handler, ...
    func edit(config: StateConfig, for state: ViewControllerState, error: Error?) -> StateConfig {
        var modifiedConfig = config
        switch state {
        case .error:
            modifiedConfig.actionHandler = { [weak listener] in
                listener?.refreshTrigger.accept(())
            }
        default:
            modifiedConfig.actionHandler = { [weak listener] in
                listener?.backTrigger.accept(())
            }
        }
        return modifiedConfig
    }
}
```

3. Update View State

Using:

```
yourViewController.startLoading(animated: true)

yourViewController.endLoading(animated: true error: someError)
```


## Advanced Usage

### ViewControllerState

`StateViewPresentable` supports 4 difference basic states: `content, loading, empty, error` and 5 additional states:

- `forceUpdate`: When the app needs to update to newer version.
- `maintenance`: When the API is being maintained.
- `permission`: When the screen need access to phone photos, contacts, ... .
- `notFound`: When the data user is looking for doesn't exist.
- `buildUp`: For the developing functions.

You can add more states by extending `ViewControllerState`, and adapt this function in your view controller:

```
func state(from error: Error) -> ViewControllerState {
    if error.errorCode = 6969 {
        return .customState
    }
    return .error
}
```

### Force transition

By default, the ViewController will automatically update state after you call `startLoading` and `endLoading`. But if you need to quickly display a specific state:

```
self.transition(to: .maintaince)
```
