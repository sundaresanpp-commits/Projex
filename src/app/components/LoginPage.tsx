import { useState } from 'react';
import { GraduationCap, AlertCircle, Eye, EyeOff } from 'lucide-react';
import { Button } from '@/app/components/ui/button';
import { Input } from '@/app/components/ui/input';
import { Label } from '@/app/components/ui/label';
import { Alert, AlertDescription } from '@/app/components/ui/alert';

interface LoginPageProps {
  onLogin: (user: { name: string; email: string; college: string; department: string }) => void;
}

export function LoginPage({ onLogin }: LoginPageProps) {
  const [isRegister, setIsRegister] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [name, setName] = useState('');
  const [college, setCollege] = useState('');
  const [department, setDepartment] = useState('');
  const [error, setError] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  // College email validation
  const isValidCollegeEmail = (email: string): boolean => {
    const collegeEmailPatterns = [
      /\.edu$/i,           // US colleges (.edu)
      /\.ac\.\w+$/i,       // International universities (.ac.in, .ac.uk, etc.)
      /\.edu\.\w+$/i,      // Some international (.edu.in, .edu.au, etc.)
    ];
    
    return collegeEmailPatterns.some(pattern => pattern.test(email));
  };

  // Extract college name from email
  const extractCollege = (email: string): string => {
    const domain = email.split('@')[1]?.split('.')[0];
    if (!domain) return '';
    
    // Convert to title case
    return domain
      .split(/[-_]/)
      .map(word => word.charAt(0).toUpperCase() + word.slice(1))
      .join(' ');
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    if (isRegister) {
      // Registration validation
      if (!isValidCollegeEmail(email)) {
        setError('Please use a valid college email address (.edu, .ac.in, etc.)');
        return;
      }

      if (password.length < 6) {
        setError('Password must be at least 6 characters long');
        return;
      }

      if (password !== confirmPassword) {
        setError('Passwords do not match');
        return;
      }

      if (!name.trim()) {
        setError('Please enter your full name');
        return;
      }

      if (!department.trim()) {
        setError('Please enter your department');
        return;
      }

      // Auto-fill college from email if not provided
      const finalCollege = college.trim() || extractCollege(email);

      // Registration successful
      onLogin({
        name: name.trim(),
        email: email.toLowerCase(),
        college: finalCollege,
        department: department.trim()
      });
    } else {
      // Login validation
      if (!email || !password) {
        setError('Please enter both email and password');
        return;
      }

      // For demo purposes, accept any login
      // In production, this would validate against stored credentials
      onLogin({
        name: 'Demo User',
        email: email.toLowerCase(),
        college: extractCollege(email) || 'Demo College',
        department: 'Computer Science'
      });
    }
  };

  const toggleMode = () => {
    setIsRegister(!isRegister);
    setError('');
    setEmail('');
    setPassword('');
    setConfirmPassword('');
    setName('');
    setCollege('');
    setDepartment('');
    setShowPassword(false);
    setShowConfirmPassword(false);
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-50 px-4">
      <div className="w-full max-w-md">
        {/* Logo and Title */}
        <div className="text-center mb-8">
          <div className="flex justify-center mb-4">
            <div className="bg-indigo-600 p-4 rounded-2xl">
              <GraduationCap className="size-12 text-white" />
            </div>
          </div>
          <h1 className="text-3xl mb-2 text-gray-900">Project Showcase</h1>
          <p className="text-gray-600">Academic Innovation Platform</p>
        </div>

        {/* Login/Register Form */}
        <div className="bg-white rounded-2xl shadow-lg p-8 border border-gray-100">
          <h2 className="text-xl text-gray-900 mb-6 text-center">
            {isRegister ? 'Create Account' : 'Welcome Back'}
          </h2>

          {error && (
            <Alert variant="destructive" className="mb-6">
              <AlertCircle className="size-4" />
              <AlertDescription>{error}</AlertDescription>
            </Alert>
          )}

          <form onSubmit={handleSubmit} className="space-y-5">
            {isRegister && (
              <div className="space-y-2">
                <Label htmlFor="name">Full Name</Label>
                <Input
                  id="name"
                  type="text"
                  placeholder="Enter your full name"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  required
                  className="h-11"
                />
              </div>
            )}

            <div className="space-y-2">
              <Label htmlFor="email">College Email ID</Label>
              <Input
                id="email"
                type="email"
                placeholder="your.name@college.edu"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="h-11"
              />
              {isRegister && email && !isValidCollegeEmail(email) && (
                <p className="text-sm text-amber-600">
                  Please use a valid college email (.edu, .ac.in, etc.)
                </p>
              )}
            </div>

            {isRegister && (
              <>
                <div className="space-y-2">
                  <Label htmlFor="college">College/University Name (Optional)</Label>
                  <Input
                    id="college"
                    type="text"
                    placeholder="Auto-filled from email or enter manually"
                    value={college}
                    onChange={(e) => setCollege(e.target.value)}
                    className="h-11"
                  />
                  {email && !college && (
                    <p className="text-sm text-gray-500">
                      Will auto-fill as: {extractCollege(email)}
                    </p>
                  )}
                </div>

                <div className="space-y-2">
                  <Label htmlFor="department">Department/Branch</Label>
                  <Input
                    id="department"
                    type="text"
                    placeholder="e.g., Computer Science"
                    value={department}
                    onChange={(e) => setDepartment(e.target.value)}
                    required
                    className="h-11"
                  />
                </div>
              </>
            )}

            <div className="space-y-2">
              <Label htmlFor="password">Password</Label>
              <div className="relative">
                <Input
                  id="password"
                  type={showPassword ? "text" : "password"}
                  placeholder={isRegister ? "Minimum 6 characters" : "Enter your password"}
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  className="h-11"
                />
                <button
                  type="button"
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500"
                  onClick={() => setShowPassword(!showPassword)}
                >
                  {showPassword ? <EyeOff className="size-5" /> : <Eye className="size-5" />}
                </button>
              </div>
            </div>

            {isRegister && (
              <div className="space-y-2">
                <Label htmlFor="confirmPassword">Confirm Password</Label>
                <div className="relative">
                  <Input
                    id="confirmPassword"
                    type={showConfirmPassword ? "text" : "password"}
                    placeholder="Re-enter your password"
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    required
                    className="h-11"
                  />
                  <button
                    type="button"
                    className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500"
                    onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                  >
                    {showConfirmPassword ? <EyeOff className="size-5" /> : <Eye className="size-5" />}
                  </button>
                </div>
              </div>
            )}

            <Button type="submit" className="w-full h-11 bg-indigo-600 hover:bg-indigo-700">
              {isRegister ? 'Create Account' : 'Sign In'}
            </Button>
          </form>

          <div className="mt-6 pt-6 border-t border-gray-200 text-center">
            <p className="text-sm text-gray-600">
              {isRegister ? 'Already have an account?' : "Don't have an account?"}{' '}
              <button 
                type="button"
                onClick={toggleMode}
                className="text-indigo-600 hover:text-indigo-700 font-medium"
              >
                {isRegister ? 'Sign In' : 'Register with College Email'}
              </button>
            </p>
          </div>
        </div>

        {/* Footer */}
        <p className="text-center text-sm text-gray-500 mt-8">
          Showcase your innovations. Build your portfolio. Connect with peers.
        </p>
      </div>
    </div>
  );
}