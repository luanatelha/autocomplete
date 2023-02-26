# Autocomplete Text Field
This is a autocomplete text field component solution for different kind of content, with custom cells and search methods.


## Usage

For each textField supposed to present the Autocomplete, there should be created a different `AutocompleteModel` containing the following structure:

### Required elements
1. `var textFieldView: UIView`: textfield supposed to show this autocomplete model
2. `var textFieldFrame: CGRect`: the frame of the textField, comparing with it's parent view
3. `var cellType: UITableViewCell.Type`: the class of the cell that should be shown in the autocomplete
4. `var heightForCells: CGFloat`: the estimated height of the cell to estimate the autocomplete size
5. `var setupCell: ((UITableView, IndexPath, AutocompleteSearchableItemProtocol?) -> UITableViewCell)`: the code to create the cell in cellForRow dataSource method

### Optional elements
1. `var items: [AutocompleteSearchableItemProtocol]?`: this is set by autocompleteModel during the filtering process
2. `var hasAdditionalItem: Bool?`: should be set to true in case there's a need to have an additional non searchable element in the autocomplete table, such as a button for an additional action
3. `var additionalItemType: UITableViewCell.Type?`: type of that additional optional element
4. `var heightForAdditionalItem: CGFloat?`: estimated height for this additional element
5. `var onItemSelection: ((_ item: AutocompleteSearchableItemProtocol) -> Void)?`: the action of selecting an element from autocomplete table
6. `var onAdditionalItemSelection: (() -> Void)?`: the action for selecting the additional optional element in the autocomplete table
7. `var setupAdditionalCell: ((UITableView, IndexPath) -> UITableViewCell)?`: the code to create the cell in cellForRow for the additional optional element

### Protocol

The items presented in the autocomplete table should conform the `AutocompleteSearchableItemProtocol`:
* `func search(_ searchText: String) -> Bool`: this method should determine the type of search to be made in the items list
