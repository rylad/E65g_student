//
//  Grid.swift
//
import Foundation

let finalProjectURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"

fileprivate func norm(_ val: Int, to size: Int) -> Int { return ((val % size) + size) % size }

fileprivate let lazyPositions = { (size: GridSize) in
    return (0 ..< size.rows)
        .lazy
        .map { zip( [Int](repeating: $0, count: size.cols) , 0 ..< size.cols ) }
        .flatMap { $0 }
        .map { GridPosition(row: $0.0,col: $0.1) }
}


fileprivate let offsets: [GridPosition] = [
    GridPosition(row: -1, col:  -1), GridPosition(row: -1, col:  0), GridPosition(row: -1, col:  1),
    GridPosition(row:  0, col:  -1),                                 GridPosition(row:  0, col:  1),
    GridPosition(row:  1, col:  -1), GridPosition(row:  1, col:  0), GridPosition(row:  1, col:  1)
]

extension GridProtocol {
    public var description: String {
        return lazyPositions(self.size)
            .map { (self[$0.row, $0.col].isAlive ? "*" : " ") + ($0.col == self.size.cols - 1 ? "\n" : "") }
            .joined()
    }
    
    private func neighborStates(of pos: GridPosition) -> [CellState] {
        return offsets.map { self[pos.row + $0.row, pos.col + $0.col] }
    }
    
    private func nextState(of pos: GridPosition) -> CellState {
        let iAmAlive = self[pos.row, pos.col].isAlive
        let numLivingNeighbors = neighborStates(of: pos).filter({ $0.isAlive }).count
        switch numLivingNeighbors {
        case 2 where iAmAlive,
             3: return iAmAlive ? .alive : .born
        default: return iAmAlive ? .died  : .empty
        }
    }
    
    public func next() -> Grid {
        var nextGrid = Grid(size) { _ in .empty }
        lazyPositions(self.size).forEach { nextGrid[$0.row, $0.col] = self.nextState(of: $0) }
        return nextGrid
    }
}

public struct Grid: GridProtocol, GridViewDataSource {

    private var _cells: [[CellState]]
    public let size: GridSize
    
    public init(_ size: GridSize, cellInitializer: (GridPosition) -> CellState = { _ in .empty }) {
        _cells = [[CellState]](
            repeatElement(
                [CellState]( repeatElement(.empty, count: size.rows)),
                count: size.cols
            )
        )

        self.size=size
        lazyPositions(self.size).forEach { self[$0.row, $0.col] = cellInitializer($0) }
    }
    


    public subscript (row: Int, col: Int) -> CellState {
        get { return _cells[norm(row, to: size.rows)][norm(col, to: size.cols)] }
        set { _cells[norm(row, to: size.rows)][norm(col, to: size.cols)] = newValue }
    }

}

extension Grid: Sequence {
    fileprivate var living: [GridPosition] {
        return lazyPositions(self.size).filter { return  self[$0.row, $0.col].isAlive   }
    }
    
    public struct GridIterator: IteratorProtocol {
        private class GridHistory: Equatable {
            let positions: [GridPosition]
            let previous:  GridHistory?
            
            static func == (lhs: GridHistory, rhs: GridHistory) -> Bool {
                return lhs.positions.elementsEqual(rhs.positions, by: ==)
            }
            
            init(_ positions: [GridPosition], _ previous: GridHistory? = nil) {
                self.positions = positions
                self.previous = previous
            }
            
            var hasCycle: Bool {
                var prev = previous
                while prev != nil {
                    if self == prev { return true }
                    prev = prev!.previous
                }
                return false
            }
        }
        
        private var grid: GridProtocol
        private var history: GridHistory!
        
        init(grid: Grid) {
            self.grid = grid
            self.history = GridHistory(grid.living)
        }
        
        public mutating func next() -> GridProtocol? {
            if history.hasCycle { return nil }
            let newGrid:Grid = grid.next() as! Grid
            history = GridHistory(newGrid.living, history)
            grid = newGrid
            return grid
        }
    }
    
    public func makeIterator() -> GridIterator { return GridIterator(grid: self) }
}

public extension Grid {
    public static func gliderInitializer(pos: GridPosition) -> CellState {
        switch pos {
        case GridPosition(row: 0, col: 1), GridPosition(row: 1, col: 2),GridPosition(row: 2, col: 0), GridPosition(row: 2, col: 1), GridPosition(row: 2, col: 2): return .alive
        default: return .empty
        }
    }
}

protocol GridInfo{
    var gName: String { get set }
    var gContents: [[Int]] { get set }

    func findMax(gContents : [[Int]]) -> Int

}

class gridInfo: GridInfo{
    var gName: String
    var gContents: [[Int]]
    
    init(gName: String, gContents: [[Int]]){
        self.gName = gName
        self.gContents = gContents
    }
    
    func findMax(gContents:[[Int]]) -> Int {
        let max = self.gContents.flatMap{return $0}.max()
        return max!
    }
}

protocol FetchProtocol{
    var gName: String? { get set }
    var gContents: [[Int]]? { get set }
    var gridTypes: [String] { get set }
    var url: String { get set }

    func findMax(gContents : [[Int]]) -> Int
}



class standardFetcher: FetchProtocol {
    var gName: String?
    var gContents: [[Int]]?
    var json: NSArray?
    var jsonContent: NSArray?
    //var gridTypes: [String]
    var gridContents : [[Int]]?
    var url : String = finalProjectURL
    
    var gridTypes = [String]()
    
    
    func findMax(gContents:[[Int]]) -> Int {
        let max = gContents.flatMap{return $0}.max()
        return max!
    }
}



//MARK: standardEngine, EngineDelegate, EngineProtocol task 3
protocol EngineDelegate {
    func engineDidUpdate(withGrid: GridProtocol)
}

protocol EngineProtocol {
    var refreshRate: Double { get set }
    var refreshTimer: Timer? { get set }
    var rows: Int { get set }
    var cols: Int { get set }
    var grid: GridProtocol { get set }
    var delegate: EngineDelegate? { get set }
    var aliveState : [[Int]] { get set }

    
    func step() -> GridProtocol
    func reset() -> GridProtocol
    func saving(withGrid: GridProtocol) -> [String: [[Int]]]
}



class standardEngine: EngineProtocol {
    public static var engine: standardEngine = standardEngine(rows: 10, cols: 10, refreshRate: 10.0	)
    var grid: GridProtocol
    var refreshTimer: Timer?
    var refreshRate: Double = 0.0{
        didSet {
        if (onOff && (refreshRate > 0.0)) {
            if #available(iOS 10.0, *) {
                refreshTimer = Timer.scheduledTimer(
                    withTimeInterval: 10.01 - refreshRate,
                    repeats: true
                ) { (t: Timer) in
                    _ = self.step()
                }
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            refreshTimer?.invalidate()
            refreshTimer = nil
            }
        }
    }
    var onOff = false
    var rows: Int
    var cols: Int
    var aliveState = [[Int]]()
    var bornState = [[Int]]()
    var diedState = [[Int]]()
    var saveDict = [String: [[Int]]]()
    

    var delegate: EngineDelegate?
    
    required init(rows: Int, cols: Int, refreshRate: Double) {
        self.grid = Grid(GridSize(rows: rows, cols: cols))
        self.rows = rows
        self.cols = cols
        self.refreshRate = refreshRate

    }
    
    class func mapNew() -> standardEngine{
        return engine
    }
    
    func updateRows(row: Int){
        standardEngine.engine.rows = row
        self.rows = row
        print (self.rows)
        print (self.cols)
        grid = Grid(GridSize(rows: self.rows, cols: self.rows))
        engineUpdateNC()
        delegate?.engineDidUpdate(withGrid: grid)
    }
    
    func updateCols(col: Int){
        standardEngine.engine.cols = col
        self.cols = col
        grid = Grid(GridSize(rows: self.cols, cols: self.cols))
        engineUpdateNC()
        delegate?.engineDidUpdate(withGrid: grid)
    }
    

    
    func toggleOn(on: Bool){
        onOff=on
        refreshRate=standardEngine.engine.refreshRate
    }
    
    func engineUpdateNC(){
          let nc = NotificationCenter.default
          let name = Notification.Name(rawValue: "EngineUpdate")
          let n = Notification(name: name,
                               object: nil,
                               userInfo: ["engine" : self])
                               nc.post(n)
    }
    
    func step() -> GridProtocol {
        let newGrid = grid.next()
        grid = newGrid
        engineUpdateNC()
        delegate?.engineDidUpdate(withGrid: grid)
        return grid
    }
    
    func reset() -> GridProtocol{
        let newGrid = Grid(GridSize(rows: self.rows, cols: self.rows))
        grid = newGrid
        engineUpdateNC()
        delegate?.engineDidUpdate(withGrid: grid)
        return grid
    }
    
    func saving(withGrid: GridProtocol) -> [String:[[Int]]]{
        (0 ..< withGrid.size.rows).forEach { i in
            (0 ..< withGrid.size.cols).forEach { j in
                switch withGrid[j,i].description()
                {
                case "alive":
                    aliveState.append([j,i])
                case "born":
                    bornState.append([j,i])
                case "died":
                    diedState.append([j,i])
                default:
                    ()
                }
            }
        }
        print(aliveState)
        print(bornState)
        print(diedState)
        saveDict = ["alive": aliveState, "born": bornState, "died": diedState ]
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "refresh"),
            object:nil,
            userInfo: saveDict);
        return saveDict
    }

    
}

