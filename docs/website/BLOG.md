# How to Add a New Blog Post

This guide explains how to create and publish a new blog post.

# Blog Content Categories

### 1. **Announcements**
Use for: Big news, milestones, and general updates about the Menstrudel project.

### 2. **Release Notes**
Use for: Detailed posts about new app versions, listing specific features and bug fixes.

### 3. **Privacy**
Use for: Articles about data security, the importance of privacy, and why Menstrudel is a safe choice.

### 4. **Open Source**
Use for: Posts about the benefits of open-source software, transparency, and community contributions.

### 5. **Tech**
Use for: "Behind-the-scenes" articles explaining the technical decisions behind the app, like the "offline-first" design.

### 6. **User Stories**
Use for: Testimonials and case studies showing how real people benefit from using the app.

### 7. **App Tips**
Use for: Practical tutorials and guides to help users get the most out of Menstrudel's features.

### 8. **Wellness**
Use for: Broader lifestyle topics that relate to the menstrual cycle, such as nutrition, exercise, and stress management.

## Create a New Post

### 1. Create a New File

All blog posts are located in the `_posts` folder. To create a new post, add a new file to this directory.

The filename **must** follow this specific format:

`YYYY-MM-DD-your-post-title.md`

-   **YYYY-MM-DD:** The full date of publication.
-   **your-post-title:** A short, descriptive title with words separated by hyphens.

**Example:** `2025-09-14-new-feature-announcement.md`

### 2. Add the Front Matter

At the very top of your new file, copy and paste the following block of text. This is the "Front Matter" and it tells Jekyll important information about the post.

```yaml
---
layout: post
title: "Your Amazing Post Title Goes Here"
date: YYYY-MM-DD HH:MM:SS +0000
categories: [category1, category2]
---
```

-   **title:** The full title of the post that will be displayed on the page. Keep it inside the quotation marks.
-   **date:** The exact date and time of publication.
-   **categories:** A list of categories for the post. This is optional but useful for organization. Common categories for this site are `release notes` and `announcements`.

### 3. Write Your Content

Below the Front Matter, you can write your post using standard Markdown.

```markdown
### This is a Subheading

![This is an image](/assets/images/blog/image.png) <!-- Make sure to put your image in the `assets/images/blog` folder -->


This is a regular paragraph. You can add lists, links, and other formatting.

-   Item 1
-   Item 2
```

### 4. Publish the Post

Once you have saved your file, commit the changes and push them to your own branch using the scheme `feature/web/my-blog-example`. Once ready, make a pull request to the `dev` branch on GitHub. The website will automatically update with your new post once accepted.