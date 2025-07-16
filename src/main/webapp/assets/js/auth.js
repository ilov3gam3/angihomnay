// Enhanced Authentication JavaScript functionality
// Modern, interactive features with smooth animations

document.addEventListener('DOMContentLoaded', function() {
    initializeAuthFeatures();
});

function initializeAuthFeatures() {
    // Password visibility toggle with enhanced animation
    initializePasswordToggles();
    
    // Enhanced form validation with real-time feedback
    initializeFormValidation();
    
    // Phone number formatting with enhanced UX
    initializePhoneFormatting();
    
    // Auto-hide messages with smooth animations
    initializeMessageHandling();
    
    // Loading states for submit buttons
    initializeLoadingStates();
    
    // Enhanced input focus effects
    initializeInputEffects();
    
    // Form submission enhancements
    initializeFormSubmission();
}

function initializePasswordToggles() {
    const toggleButtons = document.querySelectorAll('.toggle-password');
    toggleButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const input = this.parentElement.querySelector('input');
            const icon = this.querySelector('i');
            
            // Add ripple effect
            createRippleEffect(this, e);
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
                
                // Add success animation
                this.style.background = 'rgba(76, 175, 80, 0.1)';
                setTimeout(() => {
                    this.style.background = '';
                }, 300);
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
                
                // Add subtle animation
                this.style.transform = 'translateY(-50%) scale(0.95)';
                setTimeout(() => {
                    this.style.transform = 'translateY(-50%)';
                }, 150);
            }
        });
    });
}

function initializeFormValidation() {
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        const inputs = registerForm.querySelectorAll('input[required]');
        
        inputs.forEach(input => {
            // Real-time validation feedback
            input.addEventListener('blur', function() {
                validateField(this);
            });
            
            input.addEventListener('input', function() {
                clearFieldError(this);
            });
        });
        
        registerForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            if (validateForm()) {
                showLoadingState(this.querySelector('.btn-register-submit'));
                this.submit();
            }
        });
    }
    
    // Login form validation
    const loginForm = document.getElementById('loginform');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('.btn-login-submit');
            showLoadingState(submitBtn);
        });
    }
}

function validateField(field) {
    const value = field.value.trim();
    const fieldName = field.name;
    let isValid = true;
    let errorMessage = '';
    
    // Remove existing error styling
    clearFieldError(field);
    
    // Validation rules
    switch(fieldName) {
        case 'name':
            if (value.length < 2) {
                errorMessage = 'Tên phải có ít nhất 2 ký tự';
                isValid = false;
            } else if (value.length > 50) {
                errorMessage = 'Tên không được quá 50 ký tự';
                isValid = false;
            }
            break;
            
        case 'email':
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(value)) {
                errorMessage = 'Email không đúng định dạng';
                isValid = false;
            }
            break;
            
        case 'phone':
            const phoneRegex = /^(0|84)(3[2-9]|5[689]|7[06-9]|8[1-689]|9[0-46-9])[0-9]{7}$/;
            if (!phoneRegex.test(value)) {
                errorMessage = 'Số điện thoại không đúng định dạng';
                isValid = false;
            }
            break;
            
        case 'password':
            if (value.length < 6) {
                errorMessage = 'Mật khẩu phải có ít nhất 6 ký tự';
                isValid = false;
            }
            break;
            
        case 'confirmPassword':
            const password = document.getElementById('password').value;
            if (value !== password) {
                errorMessage = 'Mật khẩu xác nhận không khớp';
                isValid = false;
            }
            break;
    }
    
    if (!isValid) {
        showFieldError(field, errorMessage);
    }
    
    return isValid;
}

function showFieldError(field, message) {
    field.style.borderColor = '#D32F2F';
    field.style.boxShadow = '0 0 0 4px rgba(211, 47, 47, 0.1)';
    
    // Create error message element
    const errorDiv = document.createElement('div');
    errorDiv.className = 'field-error';
    errorDiv.textContent = message;
    
    field.parentElement.appendChild(errorDiv);
}

function clearFieldError(field) {
    field.style.borderColor = '';
    field.style.boxShadow = '';
    
    const errorDiv = field.parentElement.querySelector('.field-error');
    if (errorDiv) {
        errorDiv.remove();
    }
}

function validateForm() {
    const registerForm = document.getElementById('registerForm');
    const inputs = registerForm.querySelectorAll('input[required]');
    let isValid = true;
    
    inputs.forEach(input => {
        if (!validateField(input)) {
            isValid = false;
        }
    });
    
    return isValid;
}

function initializePhoneFormatting() {
    const phoneInput = document.getElementById('phone');
    if (phoneInput) {
        phoneInput.addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            
            if (value.length > 0) {
                if (value.startsWith('84')) {
                    value = '0' + value.substring(2);
                }
                if (value.length > 10) {
                    value = value.substring(0, 10);
                }
            }
            
            e.target.value = value;
            
            // Add visual feedback for valid phone numbers
            if (value.length === 10) {
                this.style.borderColor = '#4CAF50';
                this.style.boxShadow = '0 0 0 4px rgba(76, 175, 80, 0.1)';
            }
        });
        
        phoneInput.addEventListener('blur', function() {
            if (this.value.length > 0 && this.value.length < 10) {
                this.style.borderColor = '#D32F2F';
                this.style.boxShadow = '0 0 0 4px rgba(211, 47, 47, 0.1)';
            }
        });
    }
}

function initializeMessageHandling() {
    const messages = document.querySelectorAll('.success-message, .error-message');
    messages.forEach(message => {
        // Add close button
        const closeBtn = document.createElement('button');
        closeBtn.innerHTML = '&times;';
        closeBtn.className = 'message-close';
        closeBtn.style.cssText = `
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: inherit;
            opacity: 0.7;
            transition: opacity 0.3s ease;
        `;
        
        closeBtn.addEventListener('click', () => {
            hideMessage(message);
        });
        
        message.style.position = 'relative';
        message.appendChild(closeBtn);
        
        // Auto-hide after 8 seconds
        setTimeout(() => {
            hideMessage(message);
        }, 8000);
    });
}

function hideMessage(message) {
    message.style.opacity = '0';
    message.style.transform = 'translateX(20px)';
    setTimeout(() => {
        message.style.display = 'none';
    }, 300);
}

function initializeLoadingStates() {
    const submitButtons = document.querySelectorAll('.btn-login-submit, .btn-register-submit');
    submitButtons.forEach(button => {
        button.addEventListener('click', function() {
            if (!this.classList.contains('btn-loading')) {
                showLoadingState(this);
            }
        });
    });
}

function showLoadingState(button) {
    const originalText = button.textContent;
    button.classList.add('btn-loading');
    button.textContent = 'Đang xử lý...';
    button.disabled = true;
    
    // Re-enable after 5 seconds (fallback)
    setTimeout(() => {
        if (button.classList.contains('btn-loading')) {
            button.classList.remove('btn-loading');
            button.textContent = originalText;
            button.disabled = false;
        }
    }, 5000);
}

function initializeInputEffects() {
    const inputs = document.querySelectorAll('.input-group input');
    inputs.forEach(input => {
        // Add floating label effect
        input.addEventListener('focus', function() {
            this.parentElement.style.transform = 'scale(1.02)';
        });
        
        input.addEventListener('blur', function() {
            this.parentElement.style.transform = 'scale(1)';
        });
        
        // Add character counter for password
        if (input.type === 'password') {
            input.addEventListener('input', function() {
                const length = this.value.length;
                const minLength = 6;
                
                if (length > 0) {
                    showPasswordStrength(this, length, minLength);
                } else {
                    hidePasswordStrength(this);
                }
            });
        }
    });
}

function showPasswordStrength(input, length, minLength) {
    let strengthIndicator = input.parentElement.querySelector('.password-strength');
    
    if (!strengthIndicator) {
        strengthIndicator = document.createElement('div');
        strengthIndicator.className = 'password-strength';
        
        const strengthBar = document.createElement('div');
        strengthBar.className = 'strength-bar';
        
        strengthIndicator.appendChild(strengthBar);
        input.parentElement.appendChild(strengthIndicator);
    }
    
    const strengthBar = strengthIndicator.querySelector('.strength-bar');
    const percentage = Math.min((length / minLength) * 100, 100);
    
    strengthBar.style.width = percentage + '%';
    
    if (length < minLength) {
        strengthBar.style.backgroundColor = '#D32F2F';
    } else if (length < minLength + 2) {
        strengthBar.style.backgroundColor = '#FF9800';
    } else {
        strengthBar.style.backgroundColor = '#4CAF50';
    }
}

function hidePasswordStrength(input) {
    const strengthIndicator = input.parentElement.querySelector('.password-strength');
    if (strengthIndicator) {
        strengthIndicator.remove();
    }
}

function initializeFormSubmission() {
    // Add form submission animation
    const forms = document.querySelectorAll('form');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            // Add subtle form animation
            this.style.transform = 'scale(0.98)';
            setTimeout(() => {
                this.style.transform = 'scale(1)';
            }, 150);
        });
    });
}

function createRippleEffect(element, event) {
    const ripple = document.createElement('span');
    const rect = element.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    const x = event.clientX - rect.left - size / 2;
    const y = event.clientY - rect.top - size / 2;
    
    ripple.style.cssText = `
        position: absolute;
        width: ${size}px;
        height: ${size}px;
        left: ${x}px;
        top: ${y}px;
        background: rgba(255, 255, 255, 0.3);
        border-radius: 50%;
        transform: scale(0);
        animation: ripple 0.6s linear;
        pointer-events: none;
    `;
    
    element.style.position = 'relative';
    element.appendChild(ripple);
    
    setTimeout(() => {
        ripple.remove();
    }, 600);
}

// Add ripple animation to CSS
const style = document.createElement('style');
style.textContent = `
    @keyframes ripple {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// Enhanced accessibility
document.addEventListener('keydown', function(e) {
    // Submit form on Enter key
    if (e.key === 'Enter' && e.target.tagName === 'INPUT') {
        const form = e.target.closest('form');
        if (form) {
            const submitBtn = form.querySelector('button[type="submit"]');
            if (submitBtn && !submitBtn.disabled) {
                submitBtn.click();
            }
        }
    }
});

// Add smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
}); 