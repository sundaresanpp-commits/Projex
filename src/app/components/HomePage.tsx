import { useState, useMemo } from 'react';
import { Search, Upload, GraduationCap, User, LogOut, Trophy, Award, FileText, MessageSquare } from 'lucide-react';
import { Input } from '@/app/components/ui/input';
import { Button } from '@/app/components/ui/button';
import { ProjectCard } from '@/app/components/ProjectCard';
import { mockProjects, searchProjects, currentUser, ProjectSection } from '@/app/data/mockData';
import { getTotalUnreadCount } from '@/app/data/mockMessages';
import { Badge } from '@/app/components/ui/badge';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/app/components/ui/select";

interface HomePageProps {
  onProjectClick: (projectId: string) => void;
  onProfileClick: (userId: string) => void;
  onUploadClick: () => void;
  onMessagesClick: () => void;
  onLogout: () => void;
}

type TabSection = 'hackathon' | 'patent' | 'academic';

export function HomePage({ onProjectClick, onProfileClick, onUploadClick, onMessagesClick, onLogout }: HomePageProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [sortBy, setSortBy] = useState('likes');
  const [activeTab, setActiveTab] = useState<TabSection>('hackathon');
  
  const unreadCount = getTotalUnreadCount(currentUser.id);

  const filteredProjects = useMemo(() => {
    let projects = searchQuery 
      ? searchProjects(searchQuery) 
      : mockProjects;

    // Filter by active tab
    if (activeTab === 'hackathon') {
      projects = projects.filter(p => p.section === 'Hackathon / Competition Winner');
    } else if (activeTab === 'patent') {
      projects = projects.filter(p => p.section === 'Patent Project');
    } else if (activeTab === 'academic') {
      projects = projects.filter(p => p.section === 'Academic / Final Year Project');
    }

    // Sort projects
    if (sortBy === 'likes') {
      projects = [...projects].sort((a, b) => b.likes - a.likes);
    } else if (sortBy === 'recent') {
      projects = [...projects].sort((a, b) => b.uploadedAt.getTime() - a.uploadedAt.getTime());
    }

    return projects;
  }, [searchQuery, sortBy, activeTab]);

  const getTabCounts = () => {
    const allProjects = searchQuery ? searchProjects(searchQuery) : mockProjects;
    return {
      hackathon: allProjects.filter(p => p.section === 'Hackathon / Competition Winner').length,
      patent: allProjects.filter(p => p.section === 'Patent Project').length,
      academic: allProjects.filter(p => p.section === 'Academic / Final Year Project').length,
    };
  };

  const counts = getTabCounts();

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200 sticky top-0 z-10 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-3">
              <div className="bg-indigo-600 p-2 rounded-lg">
                <GraduationCap className="size-6 text-white" />
              </div>
              <div>
                <h1 className="text-xl text-gray-900">Project Showcase</h1>
                <p className="text-sm text-gray-600">Academic Innovation Platform</p>
              </div>
            </div>

            <div className="flex items-center gap-3">
              <Button 
                onClick={onUploadClick}
                className="bg-indigo-600 hover:bg-indigo-700 flex items-center gap-2"
              >
                <Upload className="size-4" />
                Upload Project
              </Button>
              <Button
                variant="outline"
                onClick={onMessagesClick}
                className="border-gray-200 relative"
              >
                <MessageSquare className="size-5" />
                {unreadCount > 0 && (
                  <Badge className="absolute -top-1 -right-1 size-5 p-0 flex items-center justify-center bg-red-600 text-white text-xs">
                    {unreadCount}
                  </Badge>
                )}
              </Button>
              <Button
                variant="outline"
                size="icon"
                onClick={() => onProfileClick(currentUser.id)}
                className="border-gray-200"
              >
                <User className="size-5" />
              </Button>
              <Button
                variant="outline"
                size="icon"
                onClick={onLogout}
                className="border-gray-200"
              >
                <LogOut className="size-5" />
              </Button>
            </div>
          </div>

          {/* Search and Sort */}
          <div className="flex gap-3 mb-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 size-4 text-gray-400" />
              <Input
                type="text"
                placeholder="Search projects by keywords, domain, or idea..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pl-10 h-11 border-gray-200"
              />
            </div>
            <Select value={sortBy} onValueChange={setSortBy}>
              <SelectTrigger className="w-[180px] h-11 border-gray-200">
                <SelectValue placeholder="Sort by" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="likes">Most Liked</SelectItem>
                <SelectItem value="recent">Most Recent</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {/* Navigation Tabs */}
          <nav className="flex gap-2 border-b border-gray-200 -mb-px">
            <button
              onClick={() => setActiveTab('hackathon')}
              className={`flex items-center gap-2 px-4 py-3 border-b-2 transition-colors ${
                activeTab === 'hackathon'
                  ? 'border-purple-600 text-purple-600'
                  : 'border-transparent text-gray-600 hover:text-gray-900 hover:border-gray-300'
              }`}
            >
              <Trophy className="size-5" />
              <span>Hackathon</span>
              <span className={`px-2 py-0.5 rounded-full text-xs ${
                activeTab === 'hackathon'
                  ? 'bg-purple-100 text-purple-700'
                  : 'bg-gray-100 text-gray-600'
              }`}>
                {counts.hackathon}
              </span>
            </button>
            
            <button
              onClick={() => setActiveTab('patent')}
              className={`flex items-center gap-2 px-4 py-3 border-b-2 transition-colors ${
                activeTab === 'patent'
                  ? 'border-amber-600 text-amber-600'
                  : 'border-transparent text-gray-600 hover:text-gray-900 hover:border-gray-300'
              }`}
            >
              <Award className="size-5" />
              <span>Patent</span>
              <span className={`px-2 py-0.5 rounded-full text-xs ${
                activeTab === 'patent'
                  ? 'bg-amber-100 text-amber-700'
                  : 'bg-gray-100 text-gray-600'
              }`}>
                {counts.patent}
              </span>
            </button>
            
            <button
              onClick={() => setActiveTab('academic')}
              className={`flex items-center gap-2 px-4 py-3 border-b-2 transition-colors ${
                activeTab === 'academic'
                  ? 'border-blue-600 text-blue-600'
                  : 'border-transparent text-gray-600 hover:text-gray-900 hover:border-gray-300'
              }`}
            >
              <FileText className="size-5" />
              <span>Projects</span>
              <span className={`px-2 py-0.5 rounded-full text-xs ${
                activeTab === 'academic'
                  ? 'bg-blue-100 text-blue-700'
                  : 'bg-gray-100 text-gray-600'
              }`}>
                {counts.academic}
              </span>
            </button>
          </nav>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 py-8">
        {searchQuery && (
          <div className="mb-6">
            <p className="text-gray-600">
              Found <span className="text-gray-900">{filteredProjects.length}</span> project(s) matching "{searchQuery}"
            </p>
          </div>
        )}

        {filteredProjects.length === 0 ? (
          <div className="text-center py-16">
            <div className="bg-gray-100 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4">
              <Search className="size-10 text-gray-400" />
            </div>
            <h3 className="text-xl text-gray-900 mb-2">No projects found</h3>
            <p className="text-gray-600">
              {searchQuery 
                ? `No projects match "${searchQuery}". Try a different search term.`
                : 'No projects available yet. Be the first to upload!'}
            </p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredProjects.map((project) => (
              <ProjectCard
                key={project.id}
                project={project}
                onClick={() => onProjectClick(project.id)}
              />
            ))}
          </div>
        )}
      </main>
    </div>
  );
}