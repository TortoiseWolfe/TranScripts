# Extract Facebook Data Export

Extract and clean a Facebook data export archive, keeping only files relevant for career/professional analysis.

## Target Directory
`Career/Facebook_Edited/private/`

## Process

1. Find any `.zip` file in the private directory
2. Unzip the archive
3. Delete irrelevant directories and media files (listed below)
4. Report what was kept for analysis

## Files to KEEP

### High Priority (Career/Professional Content)
| Directory | Purpose |
|-----------|---------|
| `personal_information/profile_information/` | Work history, education, bio, profile details |
| `connections/friends/` | Network connections |
| `connections/followers/` | Audience/professional reach |
| `your_facebook_activity/groups/` | Professional group memberships |
| `your_facebook_activity/pages/` | Company/professional pages followed |
| `your_facebook_activity/events/` | Professional events attended |
| `files/profile_pic.jpg` | Profile photo only |

### Medium Priority (Context)
| Directory | Purpose |
|-----------|---------|
| `personal_information/other_personal_information/` | Additional profile fields |
| `start_here.html` | Export navigation/index |

## Files to DELETE

### Tracking & Ads
- `ads_information/` - All ad targeting and preferences
- `apps_and_websites_off_of_facebook/` - Third-party activity tracking
- `logged_information/` - Activity logs, notifications, search history
- `security_and_login_information/` - Login/security data
- `preferences/` - Feed/memory preferences

### Social Activity (Non-Career)
- `your_facebook_activity/messages/` - Private messages
- `your_facebook_activity/posts/` - All posts and media (large, not career-focused)
- `your_facebook_activity/comments_and_reactions/` - Social activity
- `your_facebook_activity/stories/` - Ephemeral content
- `your_facebook_activity/reels/` - Short videos
- `your_facebook_activity/live_videos/` - Live streams
- `your_facebook_activity/saved_items_and_collections/` - Saved content

### Commerce & Other
- `your_facebook_activity/facebook_marketplace/` - Marketplace activity
- `your_facebook_activity/shops/` - Shopping activity
- `your_facebook_activity/facebook_payments/` - Payment history
- `your_facebook_activity/dating/` - Dating profile
- `your_facebook_activity/facebook_gaming/` - Gaming activity
- `your_facebook_activity/fundraisers/` - Fundraising
- `your_facebook_activity/polls/` - Polls
- `your_facebook_activity/voting/` - Voting reminders
- `your_facebook_activity/volunteering/` - Volunteer signups
- `your_facebook_activity/reviews/` - Reviews written
- `your_facebook_activity/meta_spark/` - AR effects
- `your_facebook_activity/bug_bounty/` - Bug reports
- `your_facebook_activity/ai/` - AI interactions
- `your_facebook_activity/navigation_bar/` - UI preferences
- `your_facebook_activity/other_activity/` - Miscellaneous
- `your_facebook_activity/activity_you're_tagged_in/` - Tagged content
- `your_facebook_activity/your_places/` - Location check-ins
- `connections/supervision/` - Parental controls

### Media Files
- All `.webp`, `.png` files (stickers, media)
- All `.mp4`, `.mov` video files
- Keep only `files/profile_pic.jpg`

## Execution Steps

```bash
# 1. Navigate to private directory
cd Career/Facebook_Edited/private/

# 2. Unzip the archive
unzip -o *.zip

# 3. Remove Zone.Identifier files (Windows artifacts)
find . -name "*.Identifier" -delete

# 4. Delete tracking and ads directories
rm -rf ads_information/
rm -rf apps_and_websites_off_of_facebook/
rm -rf logged_information/
rm -rf security_and_login_information/
rm -rf preferences/

# 5. Delete non-career activity directories
rm -rf your_facebook_activity/messages/
rm -rf your_facebook_activity/posts/
rm -rf your_facebook_activity/comments_and_reactions/
rm -rf your_facebook_activity/stories/
rm -rf your_facebook_activity/reels/
rm -rf your_facebook_activity/live_videos/
rm -rf your_facebook_activity/saved_items_and_collections/
rm -rf your_facebook_activity/facebook_marketplace/
rm -rf your_facebook_activity/shops/
rm -rf your_facebook_activity/facebook_payments/
rm -rf your_facebook_activity/dating/
rm -rf your_facebook_activity/facebook_gaming/
rm -rf your_facebook_activity/fundraisers/
rm -rf your_facebook_activity/polls/
rm -rf your_facebook_activity/voting/
rm -rf your_facebook_activity/volunteering/
rm -rf your_facebook_activity/reviews/
rm -rf your_facebook_activity/meta_spark/
rm -rf your_facebook_activity/bug_bounty/
rm -rf your_facebook_activity/ai/
rm -rf your_facebook_activity/navigation_bar/
rm -rf your_facebook_activity/other_activity/
rm -rf your_facebook_activity/activity_you're_tagged_in/
rm -rf your_facebook_activity/your_places/
rm -rf connections/supervision/

# 6. Delete media subdirectories
rm -rf personal_information/avatars/
rm -rf personal_information/avatars_store/
rm -rf personal_information/worlds/

# 7. Delete media files (keep profile pic)
find . -type f \( -name "*.webp" -o -name "*.png" -o -name "*.mp4" -o -name "*.mov" \) ! -name "profile_pic.jpg" -delete

# 8. List remaining files
find . -type f | head -50
```

## After Extraction

Report:
1. Directories kept (with file counts)
2. Directories deleted
3. Approximate size saved
4. Offer to analyze profile information against career frameworks

## Key Differences from LinkedIn Export

| Aspect | LinkedIn | Facebook |
|--------|----------|----------|
| Format | CSV files | HTML files |
| Extraction | Keep specific `.csv` files | Keep directories |
| Media | None | Heavy (delete most) |
| Size | Small (~1-5MB) | Large (100MB+) |

## Security Note

The private/ directory is gitignored. Never commit personal Facebook data to the repository.
