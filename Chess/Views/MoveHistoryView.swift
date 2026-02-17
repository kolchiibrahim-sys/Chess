//
//  MovieHistoryView.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//
import UIKit

final class MoveHistoryView: UIView {

    private let tableView = UITableView()
    private var moves: [MoveRecord] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {

        backgroundColor = .systemGray6

        tableView.register(MoveCell.self, forCellReuseIdentifier: "MoveCell")
        tableView.dataSource = self
        tableView.separatorStyle = .none

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configure(with moves: [MoveRecord]) {
        self.moves = moves
        tableView.reloadData()

        // son gedişə scroll et
        if moves.count > 0 {
            let index = IndexPath(row: moves.count - 1, section: 0)
            tableView.scrollToRow(at: index, at: .bottom, animated: true)
        }
    }
}

extension MoveHistoryView: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        moves.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MoveCell",
            for: indexPath
        ) as! MoveCell

        cell.configure(move: moves[indexPath.row], index: indexPath.row)
        return cell
    }
}
