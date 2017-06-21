## ASCustomAlertView

Custom animated alertViewcontroller with fade background mask

### Install:

~~~
pod 'ASCustomAlertView'
~~~

### Usage:
~~~~~~~
  showSuccessAlert(with: "title",
                         message: "message",
                         image: UIImage(named: "placeholder"),
                         style: .red,
                         buttons: [("Dismiss", {
                            self.dismissController(controller: self)
                         })
  ])
  

