// TODO: Member C - Add client-side form validation here

// Example: Email validation function
function validateEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

// Example: Password strength validation
function validatePassword(password) {
    // At least 6 characters
    return password.length >= 6;
}

// Add more validation functions as needed