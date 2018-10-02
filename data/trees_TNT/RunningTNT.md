# Running TNT

# 1. Modify matrices
- Remove all non discrete characters
- Add tnt file header and footer with correct number of taxa and characters
- Remove ambiguous characters (replace with ?)
- Remove ""

# 2. Load data into TNT
- File > Open Input file

# 3. Add outgroup taxa
- Data > Outgroup

# 4. Run analysis
- Type into the command line: proc TNT_run_basic.run 
(or proc TNT_run_basic_majority.run for majority rule tree)

# 5. Omit taxa from consensus
- Analyze > Estimate consensus > exclude selected taxa from consensus

# 6. Save trees
File > Tree save file > Open,parenthetical
Give tree a name
File > Tree save file > Save trees to open file
File > Tree save file > Close tree file