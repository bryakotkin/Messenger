//
//  IPixabayImagePickerModel.swift
//  tinkoff-chat
//
//  Created by Nikita on 27.04.2022.
//

import Foundation
import UIKit

protocol IPixabayImagePickerModel {
    func fetchImagesList() async throws -> ImagesList
    func fetchImage(imageURL: ImageURL) async throws -> UIImage?
    func fetchCurrentTheme() -> Theme?
}
