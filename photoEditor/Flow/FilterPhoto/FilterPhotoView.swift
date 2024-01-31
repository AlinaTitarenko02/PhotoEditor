//
//  FilterPhotoView.swift
//  photoEditor
//
//  Created by Alina Titarenko on 21.12.2023.
//

import UIKit
import Photos

class FilterPhotoView: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var customEffectCollectionView: UICollectionView!
    @IBOutlet weak var adjustLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var adjustView: UIView!
    
    @IBOutlet weak var customEffectButton: UIButton!
    @IBOutlet weak var contrastButton: UIButton!
    @IBOutlet weak var exposureButton: UIButton!
    @IBOutlet weak var highlightsButton: UIButton!
    @IBOutlet weak var brillianceButton: UIButton!
    @IBOutlet weak var effectButton: UIButton!
    @IBOutlet weak var adjustButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
    @IBOutlet weak var persentLabel: UILabel!
    
    @IBOutlet weak var sliderAdjust: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    private let viewModel: FilterPhotoViewModel!
    private var originalImage: UIImage?
    private var effectImage: UIImage?
    
    private var adjustValue = kCIInputBrightnessKey
    
    var undoManag = UndoManager()
    var selectedIndexPath = IndexPath(index: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    init(viewModel: FilterPhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupNavigationBar()
        
        setupCollectionView()
        
        activityIndicator.isHidden = true
        persentLabel.text = "0%"
        sliderAdjust.value = 0.0
        sliderAdjust.addTarget(self, action: #selector(adjustImage), for: .valueChanged)
        effectButton.layer.cornerRadius = 13.0
        adjustButton.layer.cornerRadius = 13.0
        customEffectButton.layer.cornerRadius = 13.0
        effectButton.layer.borderWidth = 1
        exposureButton.layer.borderWidth = 1
        effectButton.layer.borderColor = UIColor.tintColor.cgColor
        adjustView.isHidden = true
        
        brillianceButton.layer.borderColor = UIColor.white.cgColor
        exposureButton.layer.borderColor = UIColor.white.cgColor
        contrastButton.layer.borderColor = UIColor.white.cgColor
        highlightsButton.layer.borderColor = UIColor.white.cgColor
        
        redoButton.isHidden = true
        undoButton.isHidden = true
    }
    
    private func setupNavigationBar() {
        let save = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
        let share = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareTapped))

        navigationBar.topItem?.rightBarButtonItems = [save,share]
        
        let camera = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .done, target: self, action: #selector(cameraTapped))
        let rotate = UIBarButtonItem(image: UIImage(systemName: "rotate.right"), style: .done, target: self, action: #selector(rotateTapped))

        navigationBar.topItem?.leftBarButtonItems = [camera, rotate]
    }
    
    private func setupCollectionView() {
        let rateCellNib = UINib(nibName: EffectsCell.id, bundle: nil)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(rateCellNib, forCellWithReuseIdentifier: EffectsCell.id)
        
        customEffectCollectionView.delegate = self
        customEffectCollectionView.dataSource = self
        customEffectCollectionView.register(rateCellNib, forCellWithReuseIdentifier: EffectsCell.id)
        customEffectCollectionView.allowsMultipleSelection = false
        customEffectCollectionView.alwaysBounceVertical = true
        customEffectCollectionView.isHidden = true
    }
    
    private func fetchData() {
        self.customEffectButton.isHidden = true
        viewModel.fetchData(completion: { data in
            if !data.isEmpty {
                self.customEffectButton.isHidden = false
                self.customEffectCollectionView.reloadData()
            } else {
                self.customEffectCollectionView.isHidden = true
                self.effectButton.layer.borderWidth = 1
                self.effectButton.layer.borderColor = UIColor.tintColor.cgColor
                self.collectionView.isHidden = false
            }
        })
    }
    
    private func applyFilter(efect: EffectsSatusEnum) -> UIImage? {
        guard let image = originalImage else { return nil }
        if efect == .addItem {
            let vc = CreateEffectView(image: image, viewModel: CreateEffectViewModel())
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        return viewModel.applyFilter(efect: efect, image: image)
    }
    
    private func resetButtons() {
        let buttons = [brillianceButton, highlightsButton, contrastButton, exposureButton]
        buttons.forEach { $0?.layer.borderWidth = 0 }
        
        sliderAdjust.value = 0.0
        persentLabel.text = "0%"
    }
    
    private func resetButtonStyles() {
        effectButton.layer.borderWidth = 0
        effectButton.layer.borderColor = UIColor.tintColor.cgColor
        
        adjustButton.layer.borderWidth = 0
        adjustButton.layer.borderColor = UIColor.tintColor.cgColor
        
        customEffectButton.layer.borderWidth = 0
        customEffectButton.layer.borderColor = UIColor.tintColor.cgColor
    }
    
    // MARK: - @IBAction

    @IBAction func effectsTab(_ sender: Any) {
        collectionView.isHidden = false
        adjustView.isHidden = true
        customEffectCollectionView.isHidden = true
        resetButtonStyles()
        effectButton.layer.borderWidth = 1
        effectButton.layer.borderColor = UIColor.tintColor.cgColor
    }

    @IBAction func adjustTap(_ sender: Any) {
        collectionView.isHidden = true
        adjustView.isHidden = false
        customEffectCollectionView.isHidden = true
        resetButtonStyles()
        adjustButton.layer.borderWidth = 1
        adjustButton.layer.borderColor = UIColor.tintColor.cgColor
    }

    @IBAction func customeEffectsTap(_ sender: Any) {
        collectionView.isHidden = true
        adjustView.isHidden = true
        customEffectCollectionView.isHidden = false
        resetButtonStyles()
        customEffectButton.layer.borderWidth = 1
        customEffectButton.layer.borderColor = UIColor.tintColor.cgColor
        fetchData()
    }
    
    @IBAction func BrillianceTap(_ sender: Any) {
        adjustValue = kCIInputBrightnessKey
        adjustLabel.text = "BRIGHTNESS"
        resetButtons()
        brillianceButton.layer.borderWidth = 1
    }

    @IBAction func contrastTap(_ sender: Any) {
        adjustValue = kCIInputContrastKey
        adjustLabel.text = "CONTRAST"
        resetButtons()
        contrastButton.layer.borderWidth = 1
    }

    @IBAction func highlighterTap(_ sender: Any) {
        adjustValue = kCIInputSaturationKey
        adjustLabel.text = "SATURATION"
        resetButtons()
        highlightsButton.layer.borderWidth = 1
    }

    @IBAction func exposureTap(_ sender: Any) {
        adjustValue = kCIInputEVKey
        adjustLabel.text = "EXPOSURE"
        resetButtons()
        exposureButton.layer.borderWidth = 1
    }
    
    @IBAction func selectImage(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        let cell = collectionView.cellForItem(at: selectedIndexPath)
        cell?.layer.borderColor = UIColor.tintColor.cgColor
        cell?.layer.borderWidth = 0
        cell?.isSelected = false
        selectedIndexPath = IndexPath(row: 0, section: 0)
        let cell2 = collectionView.cellForItem(at: selectedIndexPath)
        cell2?.layer.borderColor = UIColor.tintColor.cgColor
        cell2?.layer.borderWidth = 3
        cell2?.isSelected = true
    }
    
    @IBAction func undoTap(_ sender: Any) {
        undoManag.undo()
    }
    
    @IBAction func redoTap(_ sender: Any) {
        undoManag.redo()
    }

    // MARK: - @objc
    
    @objc func updateUndoRedoButtons() {
        redoButton.isHidden = false
        undoButton.isHidden = false
    }
    
    @objc func cameraTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera is not available")
        }
    }

    @objc func rotateTapped() {
        if originalImage != nil {
            imageView.transform = imageView.transform.rotated(by: .pi / 2)
        }
    }

    @objc func shareTapped() {
        guard let shareImage = effectImage else { return }
        let items = [shareImage]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }

    @objc func saveTapped() {
        guard let saveImage = effectImage else { return }
        UIImageWriteToSavedPhotosAlbum(saveImage, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        print("Save finished!")
    }
    
    @objc func adjustImage() {
        guard let image = originalImage else { return }
        let displayinPercentage: Int = Int((sliderAdjust.value/100) * 10000)
        persentLabel.text = ("\(displayinPercentage)" + "%")
        imageView.image = viewModel.adjustImage(image: image, adjustValue: adjustValue, sliderValue: sliderAdjust.value)
    }

}

extension FilterPhotoView: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            imageView.image = pickedImage
            originalImage = pickedImage
            effectImage = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate

extension FilterPhotoView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard originalImage != nil else { return }
        viewModel.saveImage(fileName: "image1")
        if collectionView == customEffectCollectionView {
            guard let image = imageView.image else { return }
            undoManag.registerUndo(withTarget: self, handler: { [weak self] targetSelf in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.imageView.image = self.viewModel.addCustomEffects(image: image, indexPath: indexPath)
                }
                self.effectImage = self.imageView.image
            })
            self.imageView.image = viewModel.addCustomEffects(image: image, indexPath: indexPath)
        } else {
            let effect = viewModel.fillterManeger.efects[indexPath.row]
            guard let imageWithEffect = applyFilter(efect: effect) else { return }
            undoManag.registerUndo(withTarget: self, handler: { [weak self] targetSelf in
                guard let self = self else { return }
                self.effectImage = imageWithEffect
                DispatchQueue.main.async {
                    self.imageView.image = imageWithEffect
                }
            })
            self.imageView.image = imageWithEffect
            imageView.contentMode = .scaleAspectFit
        }
        
        updateUndoRedoButtons()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard originalImage != nil else { return }
        if selectedIndexPath == IndexPath(row: 0, section: 0) {
            let cell = collectionView.cellForItem(at: selectedIndexPath)
            cell?.layer.borderColor = UIColor.clear.cgColor
            cell?.layer.borderWidth = 3
            cell?.isSelected = false
        }
        selectedIndexPath = indexPath
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.tintColor.cgColor
        cell?.layer.borderWidth = 3
        cell?.isSelected = true
    }


    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard originalImage != nil else { return }
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.layer.borderWidth = 3
        cell?.isSelected = false
    }

}


// MARK: - UICollectionViewDataSource

extension FilterPhotoView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == customEffectCollectionView {
            return viewModel.customEffects.count
        } else {
            return self.viewModel.fillterManeger.efects.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EffectsCell.id, for: indexPath) as! EffectsCell
        if collectionView == customEffectCollectionView {
            cell.setup(status: .customCell, efect: nil, effect: self.viewModel.customEffects[indexPath.row])
        } else {
            cell.setup(efect: self.viewModel.fillterManeger.efects[indexPath.row], effect: nil)
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if collectionView == customEffectCollectionView {
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.viewModel.deleteCustomEffect(indexPath: indexPath)
                self?.fetchData()
            }
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                UIMenu(title: "", children: [deleteAction])
            }
        } else {
            return nil
        }
    }
    
}
