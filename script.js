document.addEventListener('DOMContentLoaded', () => {
    // Mobile Menu Toggle
    const mobileBtn = document.querySelector('.mobile-menu-toggle');
    const navMenu = document.querySelector('.nav-menu');

    if (mobileBtn) {
        mobileBtn.addEventListener('click', () => {
            navMenu.classList.toggle('active');
            // Toggle icon
            const icon = mobileBtn.querySelector('i');
            if (navMenu.classList.contains('active')) {
                icon.classList.remove('fa-bars');
                icon.classList.add('fa-xmark');
            } else {
                icon.classList.remove('fa-xmark');
                icon.classList.add('fa-bars');
            }
        });
    }

    // Sticky Navbar shadow on scroll
    const navbar = document.querySelector('.navbar');
    const backToTopBtn = document.getElementById('backToTop');

    window.addEventListener('scroll', () => {
        // Navbar effect
        if (window.scrollY > 10) {
            navbar.style.boxShadow = 'var(--shadow-hard)';
        } else {
            navbar.style.boxShadow = 'none';
            navbar.style.borderBottom = '2px solid #1E293B';
        }

        // Back to Top visibility
        if (window.scrollY > 300) {
            backToTopBtn.classList.add('visible');
        } else {
            backToTopBtn.classList.remove('visible');
        }
    });

    // Back to Top Click
    if (backToTopBtn) {
        backToTopBtn.addEventListener('click', () => {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
});

    // Package Filter Toggle (Mobile)
    const filterToggle = document.getElementById('filterToggle');
    const filterList = document.getElementById('filterList');
    const filterIcon = document.getElementById('filterIcon');
    const filterContainer = document.getElementById('packageFilterContainer');

    if (filterToggle && filterList) {
        // Toggle function
        const toggleMenu = (e) => {
            if(e) e.stopPropagation();
            const isOpen = filterList.classList.contains('active');
            
            if (isOpen) {
                filterList.classList.remove('active');
                filterIcon.style.transform = 'rotate(0deg)';
                filterToggle.setAttribute('aria-expanded', 'false');
            } else {
                filterList.classList.add('active');
                filterIcon.style.transform = 'rotate(180deg)';
                filterToggle.setAttribute('aria-expanded', 'true');
            }
        };

        filterToggle.addEventListener('click', toggleMenu);
        
        // Also allow clicking the container header area to toggle
        if(filterContainer) {
            filterContainer.addEventListener('click', (e) => {
                if(window.innerWidth <= 768 && !e.target.closest('a')) {
                     // Only toggle if not clicking a link
                     toggleMenu();
                }
            });
        }

        // Close when a link is clicked
        filterList.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', () => {
                if (window.innerWidth <= 768) {
                    // Slight delay to allow visual feedback
                    setTimeout(() => {
                        filterList.classList.remove('active');
                        filterIcon.style.transform = 'rotate(0deg)';
                        filterToggle.setAttribute('aria-expanded', 'false');
                    }, 150);
                }
            });
        });
    }


    // Product Gallery Image Switcher
    const mainImage = document.getElementById('mainImage');
    const thumbnails = document.querySelectorAll('.thumbnail-item');

    if (mainImage && thumbnails.length > 0) {
        thumbnails.forEach(thumb => {
            thumb.addEventListener('click', function() {
                // Get the source from data attribute
                const newSrc = this.getAttribute('data-src');
                
                // Fade out effect
                mainImage.style.opacity = '0.5';

                setTimeout(() => {
                    // Change image
                    mainImage.src = newSrc;
                    // Fade in
                    mainImage.style.opacity = '1';
                }, 150);

                // Update active state
                thumbnails.forEach(t => {
                    t.style.borderColor = 'transparent';
                    t.style.opacity = '0.7';
                });
                // Set active style for clicked thumbnail
                this.style.borderColor = 'var(--accent)';
                this.style.opacity = '1';
            });
        });
    }

