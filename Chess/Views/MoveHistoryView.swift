//
//  MovieHistoryView.swift
//  Chess
//
//  Created by Ibrahim Kolchi on 17.02.26.
//
import UIKit

final class MoveHistoryView: UIView {

    private var moves: [MoveRecord] = []

    private let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {

        backgroundColor = UIColor.secondarySystemBackground
        layer.cornerRadius = 12

        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])

        tableView.register(MoveCell.self, forCellReuseIdentifier: "MoveCell")
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }

    func configure(with moves: [MoveRecord]) {
        self.moves = moves
        tableView.reloadData()
        scrollToBottom()
    }

    private func scrollToBottom() {

        guard moves.count > 0 else { return }

        let lastRow = moves.count - 1
        let indexPath = IndexPath(row: lastRow, section: 0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.tableView.scrollToRow(
                at: indexPath,
                at: .bottom,
                animated: true
            )
        }
    }
}

extension MoveHistoryView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moves.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MoveCell",
                                                 for: indexPath) as! MoveCell

        cell.configure(move: moves[indexPath.row], row: indexPath.row)
        return cell
    }
}
