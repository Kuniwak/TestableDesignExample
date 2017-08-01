enum PagedElementCollection {
    static func append<Element: Hashable>(_ storedElements: [Element], and fetchedElements: [Element]) -> [Element] {
        var result = storedElements
        let set = Set(storedElements)

        fetchedElements.forEach { element in
            guard !set.contains(element) else {
                return
            }

            result.append(element)
        }

        return result
    }
}
