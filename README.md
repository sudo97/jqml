# jqml

A minimal OCaml implementation of a subset of [jq](https://stedolan.github.io/jq/) functionality for JSON data manipulation.

## Overview

jqml allows you to extract data from JSON documents using a simple path syntax. It supports:

- Accessing object fields using dot notation (e.g. `.name`)
- Accessing array elements using bracket notation (e.g. `[0]`) 
- Nested access combining both (e.g. `.users[0].name`)

## Room for improvement

- [ ] Add optional chaining
- [ ] Add support for filters
- [ ] Add support for transformations
- [ ] Add support for more complex operations
- [ ] Add support for more complex paths
- [ ] Rigth now it differs from jq, `.[1]` would not work, it would be `[1]`, this is because this is just an accessor, while jq is a full language where the dot has it's own semantics.
