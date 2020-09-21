//
//  FactoryDetailsViewController.swift
//  SimplePaginatedList
//
//  Created by Kevin Dion on 2020-09-20.
//  Copyright © 2020 Kevin Dion. All rights reserved.
//

import Combine
import Foundation
import MapKit
import UIKit

class FactoryDetailsViewController: UIViewController {
    // MARK: Outlets

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var addressNotFoundContainer: UIView!
    @IBOutlet var addressNotFoundLabel: UILabel!

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var divisionLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!

    // MARK: Properties

    private var viewModel: FactoryDetailsViewModel?
    private var cancelBag = Set<AnyCancellable>()

    // MARK: Configuration

    func configure(viewModel: FactoryDetailsViewModel) {
        self.viewModel = viewModel
    }

    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        setUpBinding()
        viewModel?.searchAddress()
    }

    private func setUpView() {
        mapView.delegate = self
        addressNotFoundLabel.adjustsFontSizeToFitWidth = true
    }

    private func setMapRegion(for coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: false)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }

    private func setUpBinding() {
        viewModel?.$isAddressFound
            .assign(to: \.isHidden, on: addressNotFoundContainer)
            .store(in: &cancelBag)

        viewModel?.$coordinate
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] coordinate in
                self?.setMapRegion(for: coordinate)
            })
            .store(in: &cancelBag)

        viewModel?.$name
            .assign(to: \.text, on: nameLabel)
            .store(in: &cancelBag)

        viewModel?.$division
            .assign(to: \.text, on: divisionLabel)
            .store(in: &cancelBag)

        viewModel?.$address
            .assign(to: \.text, on: addressLabel)
            .store(in: &cancelBag)
    }
}

extension FactoryDetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        annotationView.animatesDrop = true
        return annotationView
    }
}
