# Extract LinkedIn Data Export

Extract and clean a LinkedIn data export archive, keeping only files relevant for profile optimization.

## Target Directory
`Career/LinkedIn_Edited/private/`

## Process

1. Find any `.zip` file in the private directory
2. Unzip the archive
3. Delete irrelevant files (listed below)
4. Report what was kept for analysis

## Files to KEEP

### High Priority (Core Profile Content)
| File Pattern | Purpose |
|--------------|---------|
| `Profile.csv` | Headline, location, settings |
| `Profile Summary.csv` | About section text |
| `Positions.csv` | Work experience entries |
| `Skills.csv` | All listed skills (critical for SEO) |
| `Recommendations_Received.csv` | Social proof |
| `Education.csv` | Education entries |
| `Projects.csv` | Listed projects |
| `Certifications.csv` | Certifications shown |

### Medium Priority (Strategic Insight)
| File Pattern | Purpose |
|--------------|---------|
| `Connections.csv` | Network size for outreach planning |
| `Endorsement_Received_Info.csv` | Which skills others validate |
| `Company Follows.csv` | Target companies |
| `SavedJobAlerts.csv` | Target roles |

## Files to DELETE

- `Ad_Targeting*`
- `Causes You Care About*`
- `Registration*`
- `Receipts*`
- `PhoneNumbers*`
- `Whatsapp*`
- `Email Addresses*`
- `*messages*` (coach/learning/guide messages)
- `Rich_Media*`
- `Invitations*`
- `Publications*` (unless specifically needed)
- `Inbox*`
- `Learning*`
- `Search Queries*`
- `Security Challenges*`
- `Votes*`
- `Reactions*`
- `Comments*`
- `Shares*`
- `Hashtag*`
- `Jobs*` (job applications, not alerts)
- Any other files not in the KEEP list

## Execution Steps

```bash
# 1. Navigate to private directory
cd Career/LinkedIn_Edited/private/

# 2. Unzip the archive (handles nested .zip.zip)
unzip -o *.zip

# 3. If there's a nested zip, unzip that too
unzip -o *.zip 2>/dev/null || true

# 4. Delete irrelevant files (keep only what matters)
# 5. List remaining files for confirmation
```

## After Extraction

Report:
1. Files kept (with sizes)
2. Files deleted
3. Offer to analyze the key profile files against LinkedIn optimization frameworks

## Security Note

The private/ directory is gitignored. Never commit personal LinkedIn data to the repository.
