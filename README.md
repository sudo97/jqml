# jqml

A minimal OCaml implementation of a subset of [jq](https://stedolan.github.io/jq/) functionality for JSON data manipulation. This was implemented without consulting the jq documentation - it simply emulates the most commonly used jq features for accessing fields and array elements. Also I was sad because they were looking for OCaml dev in LinkedIn, and didn't give me an interview. Who lacks OCaml knowledge now, huh?

## Overview

jqml allows you to extract data from JSON documents using a simple path syntax. It supports:

- Accessing object fields using dot notation (e.g. `.name`)
- Accessing array elements using bracket notation (e.g. `[0]`) 
- Nested access combining both (e.g. `.users[0].name`)

See examples below:


```
# Accessing array element

$ echo '[{"x":"y"},2,3]' | dune exec jqml '[0]'
{ "x": "y" }   
```

```
# Accessing object field nested in array

$ echo '[{"x":"y"},2,3]' | dune exec jqml '[0].x'
"y" 
```

```
# Accessing object field

$ echo '{"x":"y"}' | dune exec jqml '.x'   
"y" 
```

```
# Accessing nested object field

$ echo '{"x":{"y": "z"}}' | dune exec jqml '.x.y'
"z"
```


## Room for improvement

- [x] Add support for array slicing
- [ ] Add optional chaining
- [ ] Add support for filters
- [ ] Add support for transformations
- [ ] Rigth now it differs from jq, `.[1]` would not work, it would be `[1]`, this is because this is just an accessor, while jq is a full language where the dot has it's own semantics.
- [ ] Add support for a stream of JSON separated by whitespaces.

## Important TODO

revisit representation for paths. revisit the meaning of `.` and `[]`. Add foreach. Add creation of new objects and arrays.