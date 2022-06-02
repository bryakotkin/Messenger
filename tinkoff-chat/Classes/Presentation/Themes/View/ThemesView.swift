//
//  ThemesView.swift
//  tinkoff-chat
//
//  Created by Nikita on 17.03.2022.
//

import UIKit

protocol ThemeViewDelegate: AnyObject {
    func fetchCurrentTheme() -> Theme?
    func viewTapped(_ theme: Theme)
}

class ThemesView: UIView {
    
    weak var delegate: ThemeViewDelegate?
    var currentThemeView: UIView?
    
    let classicThemeView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.lightGreen
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let dayThemeView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.lightBlue2
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let nightThemeView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColors.lightGrey3
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let classicLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "Classic"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "Day"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let nightLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.text = "Night"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupActions()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(classicThemeView)
        addSubview(dayThemeView)
        addSubview(nightThemeView)
        addSubview(classicLabel)
        addSubview(dayLabel)
        addSubview(nightLabel)
    }
    
    private func setClassicViewTapRecognizer() -> UITapGestureRecognizer {
        let classicViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(classicViewTapped))
        
        return classicViewTapRecognizer
    }
    
    private func setDayViewTapRecognizer() -> UITapGestureRecognizer {
        let dayViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dayViewTapped))

        return dayViewTapRecognizer
    }
    
    private func setNightViewTapRecognizer() -> UITapGestureRecognizer {
        let nightViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(nightViewTapped))
        
        return nightViewTapRecognizer
    }
    
    private func setupActions() {
        classicThemeView.addGestureRecognizer(setClassicViewTapRecognizer())
        dayThemeView.addGestureRecognizer(setDayViewTapRecognizer())
        nightThemeView.addGestureRecognizer(setNightViewTapRecognizer())
        
        classicLabel.addGestureRecognizer(setClassicViewTapRecognizer())
        dayLabel.addGestureRecognizer(setDayViewTapRecognizer())
        nightLabel.addGestureRecognizer(setNightViewTapRecognizer())
    }
    
    func updateTheme() {
        let theme = delegate?.fetchCurrentTheme()
        updateTheme(theme)
    }
    
    private func updateTheme(_ theme: Theme?) {
        checkCurrentBorder(theme)
        
        backgroundColor = theme?.backgroundColor
        classicLabel.textColor = theme?.labelColor
        dayLabel.textColor = theme?.labelColor
        nightLabel.textColor = theme?.labelColor
    }
    
    @objc private func classicViewTapped() {
        themeViewTapped(view: classicThemeView,
                        theme: ClassicTheme())
    }
    
    @objc private func dayViewTapped() {
        themeViewTapped(view: dayThemeView,
                        theme: DayTheme())
    }
    
    @objc private func nightViewTapped() {
        themeViewTapped(view: nightThemeView,
                        theme: NightTheme())
    }
    
    private func themeViewTapped(view: UIView, theme: Theme) {
        setDefaultBorder()
        setBorder(view)
        updateTheme(theme)
        
        delegate?.viewTapped(theme)
    }
    
    private func setBorder(_ themeView: UIView) {
        themeView.layer.borderColor = CustomColors.lightBlue.cgColor
        themeView.layer.borderWidth = 3
        currentThemeView = themeView
    }
    
    private func setDefaultBorder() {
        currentThemeView?.layer.borderColor = UIColor.clear.cgColor
        currentThemeView?.layer.borderWidth = 0
    }
    
    private func checkCurrentBorder(_ currentTheme: Theme?) {
        guard let themeType = currentTheme?.themeType else { return }
        
        switch themeType {
        case .classic:
            setBorder(classicThemeView)
        case .day:
            setBorder(dayThemeView)
        case .night:
            setBorder(nightThemeView)
        }
    }
    
    private func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        let dayThemeViewConstraint = [
            dayThemeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayThemeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dayThemeView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            dayThemeView.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            dayThemeView.heightAnchor.constraint(equalTo: dayThemeView.widthAnchor, multiplier: 1 / 5)
        ]
        
        let dayLabelConstraint = [
            dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: dayThemeView.bottomAnchor, constant: 15)
        ]
        
        let classicLabelConstraint = [
            classicLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            classicLabel.bottomAnchor.constraint(equalTo: dayThemeView.topAnchor, constant: -30)
        ]
        
        let classicThemeViewConstraint = [
            classicThemeView.bottomAnchor.constraint(equalTo: classicLabel.topAnchor, constant: -15),
            classicThemeView.heightAnchor.constraint(equalTo: dayThemeView.heightAnchor),
            classicThemeView.widthAnchor.constraint(equalTo: dayThemeView.widthAnchor),
            classicThemeView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        let nightThemeViewConstraint = [
            nightThemeView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 30),
            nightThemeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            nightThemeView.widthAnchor.constraint(equalTo: dayThemeView.widthAnchor),
            nightThemeView.heightAnchor.constraint(equalTo: dayThemeView.heightAnchor)
        ]
        
        let nightLabelConstraint = [
            nightLabel.topAnchor.constraint(equalTo: nightThemeView.bottomAnchor, constant: 15),
            nightLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        constraints.append(contentsOf: dayThemeViewConstraint)
        constraints.append(contentsOf: dayLabelConstraint)
        constraints.append(contentsOf: classicLabelConstraint)
        constraints.append(contentsOf: classicThemeViewConstraint)
        constraints.append(contentsOf: nightThemeViewConstraint)
        constraints.append(contentsOf: nightLabelConstraint)
        
        NSLayoutConstraint.activate(constraints)
    }
}
