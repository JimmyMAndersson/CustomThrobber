import UIKit

class AnimatingViewController: UIViewController {
  private var animationButton: UIButton = {
    let button = UIButton()
    button.setTitle("Do work!", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.setTitleColor(.green, for: .highlighted)
    button.backgroundColor = UIColor.yellow
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 25
    button.showsTouchWhenHighlighted = true
    button.setTitleShadowColor(.red, for: .normal)
    button.layer.shadowColor = UIColor.white.cgColor
    button.layer.shadowRadius = 5
    button.layer.shadowOffset = .zero
    return button
  }()
  
  let throbberView = ThrobberView()
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(animationButton)
    animationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
    animationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    animationButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    animationButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
    
    throbberView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(throbberView)
    throbberView.topAnchor.constraint(equalTo: animationButton.topAnchor).isActive = true
    throbberView.bottomAnchor.constraint(equalTo: animationButton.bottomAnchor).isActive = true
    throbberView.leadingAnchor.constraint(equalTo: animationButton.trailingAnchor, constant: 20).isActive = true
    throbberView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    animationButton.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  @objc func handleButtonTapped() {
    if throbberView.isAnimating {
      throbberView.stopAnimating()
      animationButton.setTitle("Do work!", for: .normal)
    } else {
      throbberView.startAnimating()
      animationButton.setTitle("Stop working!", for: .normal)
    }
  }
}
