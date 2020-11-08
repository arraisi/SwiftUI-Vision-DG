//
//  SliderAssetsViewModel.swift
//  Bank Mestika
//
//  Created by Prima Jatnika on 20/10/20.
//

import Foundation

class SliderAssetsSummaryViewModel: ObservableObject {
    
    private var _assetsModels = [SliderAssetsResponse]()
    
    @Published var assets: [SliderAssetsViewModel] = [SliderAssetsViewModel]()
    
    func getSliderAssets() {
        
        AssetsService.shared.getSliderAssets { result in
            print(result)
            switch result {
                case .success(let assets):
                    if let assets = assets {
                        self._assetsModels = assets
                        
                        DispatchQueue.main.async {
                            self.assets = assets.map(SliderAssetsViewModel.init)
                        }
                    }
                   
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}

class SliderAssetsViewModel: Identifiable {
    
    var assets: SliderAssetsResponse
    
    init(assets: SliderAssetsResponse) {
        self.assets = assets
    }
    
    var id: Int {
        assets.id
    }
    
    var imageUrl: String {
        assets.imageUrl
    }
}
