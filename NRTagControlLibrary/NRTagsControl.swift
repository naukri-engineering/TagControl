//
//  NRTagsControl.swift
//  RecruiterApp
//
//  Created by Bhumika Goyal on 22/11/17.
//  Copyright © 2017 Naukri. All rights reserved.
//

import UIKit

protocol NRTagsControlDelegate: class {
    
    func tagControl(tagsControl: NRTagsControl, tappedAtIndex: Int)
    func tagControl(arrayModel: [TagModel])
}

enum NRTagsControlMode: Int {
    case edit
    case list
}

class NRTagsControl: UIScrollView, UITextFieldDelegate, NRTagsControlDelegate, UIGestureRecognizerDelegate {
    
    var tags: [TagModel]?
    var tagInputField = UITextField()
    var tagsBackgroundColor: UIColor?
    var tagsTextColor: UIColor?
    var tagsBorderColor: UIColor?
    var tagsDeleteButtonColor: UIColor?
    var tagPlaceholder = String()
    var mode = NRTagsControlMode(rawValue: 0)
    private var tagSubviews: [UIView]?
    weak var tapDelegate: NRTagsControlDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        tags = [TagModel]()
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        tagSubviews = [UIView]()
        tagInputField = UITextField(frame: frame)
        tagInputField.delegate = self
        tagInputField.layer.cornerRadius = 0
        tagInputField.layer.borderColor = UIColor.black.cgColor
        tagInputField.backgroundColor = UIColor.white
        tagInputField.font = UIFont(name: "HelveticaNeue", size: 15)
        tagInputField.autocorrectionType = .no
        tagInputField.returnKeyType = .done
        tagInputField.becomeFirstResponder()
        if mode == .edit {
            self.addSubview(tagInputField)
        }
        
        tagPlaceholder = "Add Tag"
//        mode = NRTagsControlMode.edit
        tagsBackgroundColor = UIColor(red: 0.9, green: 0.91, blue: 0.925, alpha: 1)
        tagsDeleteButtonColor = UIColor.black
        tagsTextColor = UIColor.lightGray
        tagsBorderColor = UIColor.darkGray
        scollToLast()
    }
    
    //MARK:- LAYOUT STUFF
    override func layoutSubviews() {
        
        super.layoutSubviews()
        var contentSize = self.contentSize
        var frame = CGRect(x: 0, y: 0, width: 100, height: self.frame.size.height)
        var tempViewFrame = CGRect()
        var tagIndex = 0
        if let totalViews = tagSubviews {
            for view: UIView in totalViews {
                
                tempViewFrame = view.frame
                let index = totalViews.index(of: view)
                if index != 0 {
                    let prevView = totalViews[index!-1]
                    tempViewFrame.origin.x = prevView.frame.origin.x + prevView.frame.size.width + 4
                    
                } else {
                    tempViewFrame.origin.x = 0
                }
                tempViewFrame.origin.y = frame.origin.y
                view.frame = tempViewFrame
                if mode == .list {
                    view.tag = tagIndex
                    
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.gestureAction))
                    tapRecognizer.numberOfTapsRequired = 1
                    tapRecognizer.delegate = self
                    view.isUserInteractionEnabled = true
                    view.addGestureRecognizer(tapRecognizer)
                }
                tagIndex += 1
            }
            if mode == .edit {
                frame = tagInputField.frame
                frame.size.height = self.frame.size.height
                frame.origin.y = 0
                
                if totalViews.count == 0 {
                    frame.origin.x = 7
                } else {
                    if let view = totalViews.last {
                        frame.origin.x = view.frame.origin.x + view.frame.size.width + 4
                    }
                }
                if (self.frame.size.width - tagInputField.frame.origin.x > 100) {
                    frame.size.width = self.frame.size.width - frame.origin.x - 12
                } else {
                    frame.size.width = 100;
                }
                tagInputField.frame = frame
            } else {
                let lastTag = totalViews.last
                if (lastTag != nil) {
                    frame = (lastTag?.frame)!;
                } else {
                    frame.origin.x = 7;
                }
            }
            if tags?.count ?? 0 > 0 {
                tagInputField.placeholder = ""
            } else {
                tagInputField.placeholder = "Add Tag"
            }
        }
        contentSize.width = frame.origin.x + frame.size.width
        contentSize.height = self.frame.size.height
        
        self.contentSize = contentSize
    }
    
    func addTag(withModel tag: TagModel) {
        
        if let allTags = tags {
            for oldTag: TagModel in allTags {
                if oldTag.name == tag.name {
                    return
                }
            }
            tags?.append(tag)
            reloadTagSubviewsWithModel()
            let contentSize: CGSize = self.contentSize
            var offset: CGPoint = contentOffset
            if contentSize.width > frame.size.width  {
                if mode == .edit {
                    offset.x = tagInputField.frame.origin.x + tagInputField.frame.size.width - self.frame.size.width
                } else {
                    if let lastTag = tagSubviews?.last {
                        offset.x = lastTag.frame.origin.x + lastTag.frame.size.width - frame.size.width
                    }
                }
            } else {
                offset.x = 0
            }
            self.contentOffset = offset
            if tags?.count ?? 0 > 0 {
                tagInputField.placeholder = ""
            } else {
                tagInputField.placeholder = "Add Tag"
            }
            perform(#selector(self.showKeyBoardAutomatically), with: nil, afterDelay: 0.1)
        }
    }
    
    @objc func showKeyBoardAutomatically() {
        tagInputField.becomeFirstResponder()
    }
    
    func reloadTagSubviewsWithModel() {
        
        if let totalViews = tagSubviews {
            for view in totalViews {
                view.removeFromSuperview()
            }
            tagSubviews?.removeAll()
            
            let tagBorderColr = tagsBorderColor != nil ? tagsBorderColor : UIColor.darkGray
            let tagBgColor = tagsBackgroundColor != nil ? tagsBackgroundColor : UIColor(red: 0.9, green: 0.91, blue: 0.925, alpha: 1)
            let tagTxtColor = tagsTextColor != nil ? tagsTextColor:UIColor.darkGray
            let tagDeleteBtnColor = tagsDeleteButtonColor != nil ? tagsDeleteButtonColor: UIColor.black
            
            for tag in tags! {
                if let str = tag.name {
                    let width = str.boundingRect(
                        with: CGSize(width: 3000, height: tagInputField.frame.size.height),
                        options: .usesLineFragmentOrigin,
                        attributes: [NSAttributedStringKey.font: tagInputField.font!],
                        context: nil).size.width
                    
                    let tagView = UIView.init(frame: tagInputField.frame)
                    var tagFrame = tagView.frame
                    tagView.layer.cornerRadius = 0
                    tagFrame.origin.y = tagInputField.frame.origin.y
                    tagView.backgroundColor = tagBgColor
                    tagView.layer.borderColor = tagBorderColr?.cgColor
                    tagView.layer.borderWidth = 1.0
                    
                    let tagLabel = UILabel()
                    var labelFrame = tagLabel.frame
                    tagLabel.font = tagInputField.font
                    labelFrame.size.width = (width) + 16
                    labelFrame.size.height = tagInputField.frame.size.height
                    tagLabel.text = tag.name
                    
                    tagLabel.textColor = tagTxtColor
                    tagLabel.textAlignment = NSTextAlignment.center
                    tagLabel.clipsToBounds = true
                    tagLabel.layer.cornerRadius = 0
                    
                    if mode == .edit {
                        
                        let deleteTagBtn = UIButton.init(frame: tagInputField.frame)
                        var buttonFrame = deleteTagBtn.frame
                        deleteTagBtn.titleLabel?.font = tagInputField.font
                        deleteTagBtn.addTarget(self, action: #selector(deleteTagButton), for: UIControlEvents.touchUpInside)
                        buttonFrame.size.width = deleteTagBtn.frame.size.height
                        buttonFrame.size.height = tagInputField.frame.size.height
                        deleteTagBtn.tag = totalViews.count
                        deleteTagBtn.setImage(UIImage(named: "crossgrey"), for: UIControlState.normal)
                        deleteTagBtn.setTitleColor(tagDeleteBtnColor, for: UIControlState.normal)
                        buttonFrame.origin.y = 0;
                        buttonFrame.origin.x = labelFrame.size.width;
                        
                        deleteTagBtn.frame = buttonFrame;
                        tagFrame.size.width = labelFrame.size.width + buttonFrame.size.width;
                        tagView.addSubview(deleteTagBtn)
                        labelFrame.origin.x = 0
                        
                    } else {
                        tagFrame.size.width = labelFrame.size.width + 5
                        labelFrame.origin.x = (tagFrame.size.width - labelFrame.size.width) * 0.5
                    }
                    tagView.addSubview(tagLabel)
                    labelFrame.origin.y = 0
                    if let lastView = totalViews.last{
                        tagFrame.origin.x = lastView.frame.origin.x + lastView.frame.size.width + 4
                    }
                    
                    tagLabel.frame = labelFrame
                    tagView.frame = tagFrame
                    tagSubviews?.append(tagView)
                    self.addSubview(tagView)
                }
                
            }
            
            if (mode == .edit) {
                if (tagInputField.superview == nil) {
                    self.addSubview(tagInputField)
                }
                var frame = tagInputField.frame
                if (totalViews.count == 0) {
                    frame.origin.x = 7
                } else {
                    if let view = totalViews.last {
                        frame.origin.x = view.frame.origin.x + view.frame.size.width + 4
                    }
                }
                tagInputField.frame = frame
                
            } else {
                if (tagInputField.superview != nil) {
                    tagInputField.removeFromSuperview()
                }
            }
            if tags?.count ?? 0 > 0 {
                tagInputField.placeholder = ""
            } else {
                tagInputField.placeholder = "Add Tag"
            }
            self.scollToLast()
        }
    }
    
    func scollToLast() {
        self.scrollRectToVisible(CGRect(x: self.contentSize.width - 5, y: self.contentSize.height - 1, width: 1, height: 1), animated: true)
    }
    
    func tagControl(tagsControl: NRTagsControl, tappedAtIndex: Int) {
        print("tappedAtIndex")
    }
    
    func tagControl(arrayModel: [TagModel]) {
        
        print(arrayModel.count.description)
    }
    //MARK:- UIButton Handlers
    
    @objc func deleteTagButton(_ sender: UIButton) {
        if let view = sender.superview {
            view.removeFromSuperview()
            if let index = tagSubviews?.index(of: view) {
                tags?.remove(at: index)
            }
        }
        reloadTagSubviewsWithModel()
    }
    
    //MARK:- TEXT FIELD STUFF
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let trimmedString = textField.text?.trimmingCharacters(in: .whitespaces)
        if trimmedString == "" {
            
            textField.resignFirstResponder()
            return true
        }
        var tagModel = TagModel()
        tagModel.name = trimmedString
        tagModel.id = tags?.count.description
        addTag(withModel: tagModel)
        tagInputField.text = ""
        tapDelegate?.tagControl(arrayModel: tags!)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func setMode(mode: NRTagsControlMode) {
        self.mode = mode
    }
    
    func setTags(tag: NSMutableArray) {
        self.tags = tag as? [TagModel]
    }
    
    func setPlaceholder(tagPlaceholder: String) {
        self.tagPlaceholder = tagPlaceholder
    }
    
    @objc func gestureAction(_ sender: Any) {
        
        let tapRecognizer = sender as? UITapGestureRecognizer
        tapDelegate?.tagControl(tagsControl: self, tappedAtIndex: (tapRecognizer?.view?.tag)!)
    }
}

