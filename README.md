# Neverlang-SQL
This repository defines a DSL that implements the core features of SQL.
The project has been developed using the Neverlang Language Workbench, a framework that facilitates the creation of Domain-Specific Languages (DSLs) in an agile manner.

At this stage, the following features have been implemented:
- [x] The ability to use multiple queries in a single input;
- [x] Management (adding, modifying and deleting) of both tables and data tuples;
- [x] Query output, in particular using the `SELECT`, `WHERE` and `ORDER BY` clauses;
- [x] Ability to aggregate data using `GROUP BY` and the associated aggregation functions (`COUNT`, `SUM`, `AVG`, `MIN` and `MAX`).

The framework used is designed to encourage language modularity; new language features/components can be added by simply adding new modules or slices.
