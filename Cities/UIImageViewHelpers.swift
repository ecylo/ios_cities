//
//  UIImageViewHelpers.swift
//  Cities
//
//  Created by Ewelina on 09/02/2021.
//

import UIKit

extension UIImageView {

	func setImage(from url: URL) {
		// TODO: Use dedicated library - like Kingfisher - to manage loading
		//		 and caching images from the network:
		image = nil
		DispatchQueue.global(qos: .userInteractive).async { [weak self] in
			if let data =  try? Data(contentsOf: url) {
				DispatchQueue.main.async {
					self?.image = UIImage(data: data)
				}
			}
		}
	}
}
