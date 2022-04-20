//
//  ThemesView.swift
//  tinkoff-chat
//
//  Created by Nikita on 17.03.2022.
//

import UIKit

protocol ThemeViewDelegate: AnyObject {
    func viewTapped(_ theme: Themes)
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
        
        updateTheme()
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
    
    private func updateTheme(_ theme: Theme? = nil) {
        var currentTheme: Theme?
        
        if let theme = theme {
            currentTheme = theme
        } else {
            currentTheme = ServiceAssembly.themeService.currentTheme
        }
        
        checkCurrentBorder(currentTheme)
        
        backgroundColor = currentTheme?.backgroundColor
        classicLabel.textColor = currentTheme?.labelColor
        dayLabel.textColor = currentTheme?.labelColor
        nightLabel.textColor = currentTheme?.labelColor
    }
    
    @objc private func classicViewTapped() {
        setDefaultBorder()
        setBorder(classicThemeView)
        
        let classicTheme = ClassicTheme()
        updateTheme(classicTheme)
        
        delegate?.viewTapped(.classic)
    }
    
    @objc private func dayViewTapped() {
        setDefaultBorder()
        setBorder(dayThemeView)
        
        let dayTheme = DayTheme()
        updateTheme(dayTheme)
        
        delegate?.viewTapped(.day)
    }
    
    @objc private func nightViewTapped() {
        setDefaultBorder()
        setBorder(nightThemeView)
        
        let nightTheme = NightTheme()
        updateTheme(nightTheme)
        
        delegate?.viewTapped(.night)
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
        if (currentTheme as? NightTheme) != nil {
            setBorder(nightThemeView)
            return
        }
        if (currentTheme as? DayTheme) != nil {
            setBorder(dayThemeView)
            return
        }
        if (currentTheme as? ClassicTheme) != nil {
            setBorder(classicThemeView)
            return
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
