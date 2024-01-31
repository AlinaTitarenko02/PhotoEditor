//
//  CreateEffectView.swift
//  photoEditor
//
//  Created by Alina Titarenko on 04.01.2024.
//

import UIKit
import SwiftData

class CreateEffectView: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var exposureLabel: UILabel!
    @IBOutlet weak var eposureSlider: UISlider!
    
    @IBOutlet weak var brillianceLabel: UILabel!
    @IBOutlet weak var brillianceSlider: UISlider!
    
    @IBOutlet weak var highlightsLabel: UILabel!
    @IBOutlet weak var highlightsSlider: UISlider!
    
    @IBOutlet weak var contrastLabel: UILabel!
    @IBOutlet weak var contrastSlider: UISlider!
    
    let image: UIImage
    private let viewModel: CreateEffectViewModel!
    var adjustValue: String = ""
    var selectEffectName: EffectsSatusEnum = .none
    
    init(image: UIImage, viewModel: CreateEffectViewModel) {
        self.image = image
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        setupSlider()
        setupColectionView()
    }
    
    private func setupColectionView() {
        let effectCellNib = UINib(nibName: EffectsCell.id, bundle: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(effectCellNib, forCellWithReuseIdentifier: EffectsCell.id)
    }
    
    private func setupSlider() {
        eposureSlider.value = 0
        contrastSlider.value = 0
        brillianceSlider.value = 0
        highlightsSlider.value = 0
        
        eposureSlider.addTarget(self, action: #selector(adjustExposureImage), for: .valueChanged)
        contrastSlider.addTarget(self, action: #selector(adjustBrillianceImage), for: .valueChanged)
        brillianceSlider.addTarget(self, action: #selector(adjustHighlightsImage), for: .valueChanged)
        highlightsSlider.addTarget(self, action: #selector(adjustContrastImage), for: .valueChanged)
    }
    
    @objc func adjustExposureImage() {
        guard let image = imageView.image else { return }
        adjustValue = kCIInputEVKey
        imageView.image = viewModel.adjustImage(image: image, adjustValue: adjustValue, sliderValue: eposureSlider.value)
    }
    
    @objc func adjustBrillianceImage() {
        guard let image = imageView.image else { return }
        adjustValue = kCIInputBrightnessKey
        imageView.image = viewModel.adjustImage(image: image, adjustValue: adjustValue, sliderValue: brillianceSlider.value)
    }
    
    @objc func adjustHighlightsImage() {
        guard let image = imageView.image else { return }
        adjustValue = kCIInputSaturationKey
        imageView.image = viewModel.adjustImage(image: image, adjustValue: adjustValue, sliderValue: highlightsSlider.value)
    }
    
    @objc func adjustContrastImage() {
        guard let image = imageView.image else { return }
        adjustValue = kCIInputContrastKey
        imageView.image = viewModel.adjustImage(image: image, adjustValue: adjustValue, sliderValue: contrastSlider.value)
    }

    @IBAction func closeTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveEffectsTap(_ sender: Any) {
        let alertController = UIAlertController(title: "Сохранить", message: "Вы хотите сохранить изменения?", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Имя фильтра"
        }

        alertController.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            guard let textField = alertController.textFields?.first, let text = textField.text else { return }
            let effect = PhotoModel(id: UUID().uuidString,name: text, effect: self.selectEffectName.rawValue, eposureSliderValue: self.eposureSlider.value, brillianceSliderValue: self.brillianceSlider.value, highlightsSliderValue: self.highlightsSlider.value,  contrastSliderValue: self.contrastSlider.value)
            self.viewModel.saveCustomEffect(effect: effect)
            self.dismiss(animated: true, completion: nil)
        }))

        alertController.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate

extension CreateEffectView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let effect = viewModel.fillterManeger.efects[indexPath.row]
        guard let imageWithEffect = viewModel.applyFilter(efect: effect, image: imageView.image!) else { return }
        imageView.image = imageWithEffect
        imageView.contentMode = .scaleAspectFit
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectEffectName = viewModel.fillterManeger.efects[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.tintColor.cgColor
        cell?.layer.borderWidth = 3
        cell?.isSelected = true
    }


    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.layer.borderWidth = 3
        cell?.isSelected = false
    }

}


// MARK: - UICollectionViewDataSource

extension CreateEffectView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.fillterManeger.forCustomEfects.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EffectsCell.id, for: indexPath) as! EffectsCell

        cell.setup(efect: self.viewModel.fillterManeger.forCustomEfects[indexPath.row], effect: nil)
    
        return cell
    }
}

