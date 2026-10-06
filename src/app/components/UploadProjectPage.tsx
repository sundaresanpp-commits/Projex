import { useState } from 'react';
import { ArrowLeft, Upload, Image as ImageIcon, X, UserPlus } from 'lucide-react';
import { Button } from '@/app/components/ui/button';
import { Input } from '@/app/components/ui/input';
import { Label } from '@/app/components/ui/label';
import { Textarea } from '@/app/components/ui/textarea';
import { Card } from '@/app/components/ui/card';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/app/components/ui/select";
import { Badge } from '@/app/components/ui/badge';
import { mockUsers, ProjectSection, currentUser } from '@/app/data/mockData';

interface UploadProjectPageProps {
  onBack: () => void;
  onSubmit: () => void;
}

export function UploadProjectPage({ onBack, onSubmit }: UploadProjectPageProps) {
  const [step, setStep] = useState(1);
  const [formData, setFormData] = useState({
    title: '',
    section: '' as ProjectSection | '',
    domain: '',
    college: currentUser.college,
    mentorName: '',
    problemStatement: '',
    year: new Date().getFullYear(),
    teamMembers: [] as string[],
    imagePreview: null as string | null
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // In a real app, this would submit to backend
    console.log('Project submitted:', formData);
    onSubmit();
  };

  const handleImageUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setFormData({ ...formData, imagePreview: reader.result as string });
      };
      reader.readAsDataURL(file);
    }
  };

  const addTeamMember = (userId: string) => {
    if (!formData.teamMembers.includes(userId)) {
      setFormData({ 
        ...formData, 
        teamMembers: [...formData.teamMembers, userId] 
      });
    }
  };

  const removeTeamMember = (userId: string) => {
    setFormData({ 
      ...formData, 
      teamMembers: formData.teamMembers.filter(id => id !== userId) 
    });
  };

  const availableMembers = mockUsers.filter(u => u.id !== currentUser.id);

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200 sticky top-0 z-10 shadow-sm">
        <div className="max-w-4xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <Button 
              variant="ghost" 
              onClick={onBack}
              className="flex items-center gap-2 text-gray-600 hover:text-gray-900"
            >
              <ArrowLeft className="size-4" />
              Cancel
            </Button>
            <div className="flex items-center gap-2">
              <div className={`size-8 rounded-full flex items-center justify-center ${step >= 1 ? 'bg-indigo-600 text-white' : 'bg-gray-200 text-gray-600'}`}>
                1
              </div>
              <div className={`w-12 h-1 ${step >= 2 ? 'bg-indigo-600' : 'bg-gray-200'}`} />
              <div className={`size-8 rounded-full flex items-center justify-center ${step >= 2 ? 'bg-indigo-600 text-white' : 'bg-gray-200 text-gray-600'}`}>
                2
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-4xl mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-3xl mb-2 text-gray-900">Upload Project</h1>
          <p className="text-gray-600">
            {step === 1 ? 'Step 1: Project Details' : 'Step 2: Team & Images'}
          </p>
        </div>

        <form onSubmit={handleSubmit}>
          {step === 1 ? (
            <Card className="p-8 border-gray-200">
              <div className="space-y-6">
                {/* Project Section */}
                <div className="space-y-2">
                  <Label htmlFor="section">Project Section *</Label>
                  <Select 
                    value={formData.section} 
                    onValueChange={(value) => setFormData({ ...formData, section: value as ProjectSection })}
                  >
                    <SelectTrigger className="border-gray-200">
                      <SelectValue placeholder="Select project type" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="Patent Project">Patent Project</SelectItem>
                      <SelectItem value="Hackathon / Competition Winner">Hackathon / Competition Winner</SelectItem>
                      <SelectItem value="Academic / Final Year Project">Academic / Final Year Project</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                {/* Project Title */}
                <div className="space-y-2">
                  <Label htmlFor="title">Project Title *</Label>
                  <Input
                    id="title"
                    placeholder="e.g., AI-Powered Disease Diagnosis System"
                    value={formData.title}
                    onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                    required
                    className="border-gray-200"
                  />
                </div>

                {/* Domain */}
                <div className="space-y-2">
                  <Label htmlFor="domain">Domain *</Label>
                  <Input
                    id="domain"
                    placeholder="e.g., AI, Healthcare, IoT (comma-separated)"
                    value={formData.domain}
                    onChange={(e) => setFormData({ ...formData, domain: e.target.value })}
                    required
                    className="border-gray-200"
                  />
                  <p className="text-sm text-gray-500">Enter domains separated by commas</p>
                </div>

                {/* Problem Statement */}
                <div className="space-y-2">
                  <Label htmlFor="problemStatement">Problem Statement *</Label>
                  <Textarea
                    id="problemStatement"
                    placeholder="Describe the problem your project solves and its key features..."
                    value={formData.problemStatement}
                    onChange={(e) => setFormData({ ...formData, problemStatement: e.target.value })}
                    required
                    rows={6}
                    className="border-gray-200"
                  />
                  <p className="text-sm text-gray-500">
                    Explain the problem and approach (not the complete solution)
                  </p>
                </div>

                {/* College */}
                <div className="space-y-2">
                  <Label htmlFor="college">College *</Label>
                  <Input
                    id="college"
                    value={formData.college}
                    onChange={(e) => setFormData({ ...formData, college: e.target.value })}
                    required
                    className="border-gray-200"
                  />
                </div>

                {/* Mentor Name */}
                <div className="space-y-2">
                  <Label htmlFor="mentor">Mentor Name *</Label>
                  <Input
                    id="mentor"
                    placeholder="e.g., Dr. Rajesh Kumar"
                    value={formData.mentorName}
                    onChange={(e) => setFormData({ ...formData, mentorName: e.target.value })}
                    required
                    className="border-gray-200"
                  />
                </div>

                {/* Year */}
                <div className="space-y-2">
                  <Label htmlFor="year">Year *</Label>
                  <Select 
                    value={formData.year.toString()} 
                    onValueChange={(value) => setFormData({ ...formData, year: parseInt(value) })}
                  >
                    <SelectTrigger className="border-gray-200">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="2025">2025</SelectItem>
                      <SelectItem value="2024">2024</SelectItem>
                      <SelectItem value="2023">2023</SelectItem>
                      <SelectItem value="2022">2022</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <Button 
                  type="button"
                  onClick={() => setStep(2)}
                  disabled={!formData.section || !formData.title || !formData.domain || !formData.problemStatement || !formData.mentorName}
                  className="w-full bg-indigo-600 hover:bg-indigo-700"
                >
                  Continue to Team & Images
                </Button>
              </div>
            </Card>
          ) : (
            <Card className="p-8 border-gray-200">
              <div className="space-y-6">
                {/* Team Members */}
                <div className="space-y-3">
                  <Label>Team Members</Label>
                  <p className="text-sm text-gray-500">
                    Tag your team members. You'll be set as the project lead.
                  </p>
                  
                  {/* Selected Team Members */}
                  {formData.teamMembers.length > 0 && (
                    <div className="flex flex-wrap gap-2 mb-3">
                      {formData.teamMembers.map(userId => {
                        const user = mockUsers.find(u => u.id === userId);
                        return user ? (
                          <Badge 
                            key={userId}
                            variant="outline"
                            className="bg-indigo-50 text-indigo-700 border-indigo-200 flex items-center gap-2"
                          >
                            {user.name}
                            <button
                              type="button"
                              onClick={() => removeTeamMember(userId)}
                              className="hover:text-indigo-900"
                            >
                              <X className="size-3" />
                            </button>
                          </Badge>
                        ) : null;
                      })}
                    </div>
                  )}

                  {/* Available Members */}
                  <div className="border border-gray-200 rounded-lg p-4 max-h-64 overflow-y-auto">
                    <div className="space-y-2">
                      {availableMembers.map(user => (
                        <button
                          key={user.id}
                          type="button"
                          onClick={() => addTeamMember(user.id)}
                          disabled={formData.teamMembers.includes(user.id)}
                          className={`w-full flex items-center gap-3 p-3 rounded-lg transition-colors text-left ${
                            formData.teamMembers.includes(user.id)
                              ? 'bg-gray-50 text-gray-400 cursor-not-allowed'
                              : 'hover:bg-gray-50 text-gray-900'
                          }`}
                        >
                          <UserPlus className="size-4" />
                          <div className="flex-1">
                            <p>{user.name}</p>
                            <p className="text-sm text-gray-600">{user.college}</p>
                          </div>
                          {formData.teamMembers.includes(user.id) && (
                            <Badge variant="outline" className="bg-green-50 text-green-700 border-green-200">
                              Added
                            </Badge>
                          )}
                        </button>
                      ))}
                    </div>
                  </div>
                </div>

                {/* Project Image */}
                <div className="space-y-3">
                  <Label htmlFor="image">Project Image *</Label>
                  <p className="text-sm text-gray-500">
                    Upload a cover image or screenshot of your project
                  </p>
                  
                  {formData.imagePreview ? (
                    <div className="relative">
                      <img 
                        src={formData.imagePreview} 
                        alt="Preview" 
                        className="w-full h-64 object-cover rounded-lg border-2 border-gray-200"
                      />
                      <button
                        type="button"
                        onClick={() => setFormData({ ...formData, imagePreview: null })}
                        className="absolute top-2 right-2 p-2 bg-white rounded-full shadow-lg hover:bg-gray-100"
                      >
                        <X className="size-4" />
                      </button>
                    </div>
                  ) : (
                    <label 
                      htmlFor="image"
                      className="border-2 border-dashed border-gray-300 rounded-lg p-12 flex flex-col items-center justify-center cursor-pointer hover:border-indigo-400 transition-colors"
                    >
                      <ImageIcon className="size-12 text-gray-400 mb-3" />
                      <p className="text-gray-600 mb-1">Click to upload image</p>
                      <p className="text-sm text-gray-500">PNG, JPG up to 10MB</p>
                      <Input
                        id="image"
                        type="file"
                        accept="image/*"
                        onChange={handleImageUpload}
                        className="hidden"
                      />
                    </label>
                  )}
                </div>

                <div className="flex gap-3">
                  <Button 
                    type="button"
                    variant="outline"
                    onClick={() => setStep(1)}
                    className="flex-1 border-gray-200"
                  >
                    Back
                  </Button>
                  <Button 
                    type="submit"
                    disabled={!formData.imagePreview}
                    className="flex-1 bg-indigo-600 hover:bg-indigo-700"
                  >
                    <Upload className="size-4 mr-2" />
                    Publish Project
                  </Button>
                </div>
              </div>
            </Card>
          )}
        </form>
      </main>
    </div>
  );
}
