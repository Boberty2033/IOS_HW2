import UIKit

// MARK: - UIColor extension for HEX
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

// MARK: - Main ViewController
final class WishMakerViewController: UIViewController {
    
    // MARK: Constants
    private enum Constants {
        static let titleFontSize: CGFloat = 32
        static let descriptionFontSize: CGFloat = 18
        static let stackSpacing: CGFloat = 16
        static let padding: CGFloat = 20
        static let sliderMin: Float = 0
        static let sliderMax: Float = 1
        static let randomAnimationDuration: TimeInterval = 0.3
    }
    
    // MARK: UI Elements
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    private var sliderRed: CustomSlider!
    private var sliderGreen: CustomSlider!
    private var sliderBlue: CustomSlider!
    
    private var randomButton: UIButton!
    private var hexTextField: UITextField!
    
    private var slidersStack: UIStackView!
    
    private var toggleSlidersButton: UIButton!

    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        configureTitle()
        configureDescription()
        configureSliders()
        configureRandomButton()
        configureHexInput()
        updateBackgroundColor()
        configureToggleButton()
    }
    
    private func configureTitle() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "WishMaker"
        titleLabel.font = UIFont.systemFont(ofSize: Constants.titleFontSize)
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding)
        ])
    }
    
    private func configureDescription() {
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Change the background color in three ways!"
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: Constants.descriptionFontSize)
        descriptionLabel.textColor = UIColor(hex: "#FF5733")
        descriptionLabel.numberOfLines = 0
        
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.padding),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding)
        ])
    }
    
    private func configureSliders() {
        sliderRed = CustomSlider(title: "Red", min: Double(Constants.sliderMin), max: Double(Constants.sliderMax))
        sliderGreen = CustomSlider(title: "Green", min: Double(Constants.sliderMin), max: Double(Constants.sliderMax))
        sliderBlue = CustomSlider(title: "Blue", min: Double(Constants.sliderMin), max: Double(Constants.sliderMax))
        
        sliderRed.valueChanged = { [weak self] _ in self?.updateBackgroundColor() }
        sliderGreen.valueChanged = { [weak self] _ in self?.updateBackgroundColor() }
        sliderBlue.valueChanged = { [weak self] _ in self?.updateBackgroundColor() }

        slidersStack = UIStackView(arrangedSubviews: [sliderRed, sliderGreen, sliderBlue])
        slidersStack.axis = .vertical
        slidersStack.spacing = Constants.stackSpacing
        slidersStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(slidersStack)
        
        NSLayoutConstraint.activate([
            slidersStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slidersStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.padding),
            slidersStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            slidersStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding)
        ])
    }
    
    private func configureRandomButton() {
        randomButton = UIButton(type: .system)
        randomButton.translatesAutoresizingMaskIntoConstraints = false
        randomButton.setTitle("Random Color", for: .normal)
        randomButton.addTarget(self, action: #selector(randomColorTapped), for: .touchUpInside)
        
        view.addSubview(randomButton)
        NSLayoutConstraint.activate([
            randomButton.topAnchor.constraint(equalTo: slidersStack.bottomAnchor, constant: Constants.padding),
            randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureHexInput() {
        hexTextField = UITextField()
        hexTextField.translatesAutoresizingMaskIntoConstraints = false
        hexTextField.placeholder = "#RRGGBB"
        hexTextField.borderStyle = .roundedRect
        hexTextField.addTarget(self, action: #selector(hexTextChanged), for: .editingDidEndOnExit)
        
        view.addSubview(hexTextField)
        NSLayoutConstraint.activate([
            hexTextField.topAnchor.constraint(equalTo: randomButton.bottomAnchor, constant: Constants.padding),
            hexTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hexTextField.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func configureToggleButton() {
        toggleSlidersButton = UIButton(type: .system)
        toggleSlidersButton.translatesAutoresizingMaskIntoConstraints = false
        toggleSlidersButton.setTitle("Show/Hide Sliders", for: .normal)
        toggleSlidersButton.addTarget(self, action: #selector(toggleSliders), for: .touchUpInside)

        view.addSubview(toggleSlidersButton)

        NSLayoutConstraint.activate([
            toggleSlidersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleSlidersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    
    // MARK: - Actions
    @objc private func randomColorTapped() {
        sliderRed.setValue(Float.random(in: Constants.sliderMin...Constants.sliderMax), animated: true)
        sliderGreen.setValue(Float.random(in: Constants.sliderMin...Constants.sliderMax), animated: true)
        sliderBlue.setValue(Float.random(in: Constants.sliderMin...Constants.sliderMax), animated: true)
        updateBackgroundColor()
    }
    
    @objc private func hexTextChanged() {
        guard let hex = hexTextField.text, !hex.isEmpty else { return }
        view.backgroundColor = UIColor(hex: hex)
        // optionally update sliders to match HEX color
    }
    
    private func updateBackgroundColor() {
        let red = CGFloat(sliderRed.value)
        let green = CGFloat(sliderGreen.value)
        let blue = CGFloat(sliderBlue.value)
        view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    @objc private func toggleSliders() {
        sliderRed.isHidden.toggle()
        sliderGreen.isHidden.toggle()
        sliderBlue.isHidden.toggle()
    }

}


// MARK: - CustomSlider
final class CustomSlider: UIView {
    var valueChanged: ((Double) -> Void)?
    private var slider = UISlider()
    private var titleView = UILabel()
    
    var value: Double {
        return Double(slider.value)
    }
    
    func setValue(_ value: Float, animated: Bool) {
        slider.setValue(value, animated: animated)
    }
    
    init(title: String, min: Double, max: Double) {
        super.init(frame: .zero)
        titleView.text = title
        slider.minimumValue = Float(min)
        slider.maximumValue = Float(max)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        for view in [titleView, slider] {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            slider.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    @objc private func sliderValueChanged() {
        valueChanged?(Double(slider.value))
    }
}
