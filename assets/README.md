# App Icon and Splash Screen Assets

## Instructions for Converting SVG to PNG

To generate the required PNG assets from the SVG files, follow these steps:

### Required Tools
- Any SVG to PNG converter (online tools like convertio.co, or local tools like Inkscape)
- Image editing software for resizing (optional)

### App Icon (app_icon.svg → app_icon.png)
Convert `app_icon.svg` to PNG at **1024x1024** resolution for high quality.

### Splash Logo (splash_logo.svg → splash_logo.png)  
Convert `splash_logo.svg` to PNG at **512x256** resolution.

### Branding (branding.svg → branding.png)
Convert `branding.svg` to PNG at **200x40** resolution.

### Flutter Commands to Generate Icons and Splash
After converting SVGs to PNGs:

```bash
# Install dependencies
flutter pub get

# Generate app icons
flutter pub run flutter_launcher_icons:main

# Generate splash screens  
flutter pub run flutter_native_splash:create

# Clean and rebuild
flutter clean
flutter pub get
```

## Design System

### Color Palette
- **Primary Dark**: #0D1B2A (Deep Navy)
- **Secondary**: #1B263B (Dark Blue)
- **Accent**: #415A77 (Steel Blue)
- **Highlight**: #4ECDC4 (Cyan)
- **Warning**: #FF6B35 (Orange)
- **Success**: #45B7B8 (Teal)

### Typography
- **Headers**: Bold, all-caps, letter-spacing: 2px
- **Body**: Regular weight, good contrast
- **UI Elements**: Medium weight for buttons and labels

### Visual Elements
- **Rounded corners**: 12-20px for cards, 32px for buttons
- **Shadows**: Subtle, 4-8px blur, low opacity
- **Gradients**: Radial and linear, using color palette
- **Icons**: Outline style, consistent stroke width

This design system ensures consistency across all app surfaces and maintains the modern, gaming-focused aesthetic.