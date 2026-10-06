import { ArrowLeft, Mail, Building2, BookOpen, Award, Trophy, FileText, Heart, MessageSquare } from 'lucide-react';
import { Button } from '@/app/components/ui/button';
import { Badge } from '@/app/components/ui/badge';
import { Card } from '@/app/components/ui/card';
import { Avatar, AvatarFallback, AvatarImage } from '@/app/components/ui/avatar';
import { Separator } from '@/app/components/ui/separator';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/app/components/ui/tabs';
import { User, getProjectsByUserId } from '@/app/data/mockData';
import { ProjectCard } from '@/app/components/ProjectCard';

interface ProfilePageProps {
  user: User;
  onBack: () => void;
  onProjectClick: (projectId: string) => void;
  onUploadClick?: () => void;
  onMessageClick?: (userId: string) => void;
  isOwnProfile?: boolean;
}

export function ProfilePage({ user, onBack, onProjectClick, onUploadClick, onMessageClick, isOwnProfile }: ProfilePageProps) {
  const userProjects = getProjectsByUserId(user.id);
  
  // Categorize projects
  const patentProjects = userProjects.filter(p => p.section === 'Patent Project');
  const hackathonProjects = userProjects.filter(p => p.section === 'Hackathon / Competition Winner');
  const academicProjects = userProjects.filter(p => p.section === 'Academic / Final Year Project');
  
  // Calculate total engagement
  const totalLikes = userProjects.reduce((sum, p) => sum + p.likes, 0);
  const totalComments = userProjects.reduce((sum, p) => sum + p.commentCount, 0);

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200 sticky top-0 z-10 shadow-sm">
        <div className="max-w-6xl mx-auto px-4 py-4">
          <Button 
            variant="ghost" 
            onClick={onBack}
            className="flex items-center gap-2 text-gray-600 hover:text-gray-900"
          >
            <ArrowLeft className="size-4" />
            Back
          </Button>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-6xl mx-auto px-4 py-8">
        {/* Profile Header */}
        <Card className="p-8 mb-8 border-gray-200">
          <div className="flex flex-col md:flex-row gap-6 items-start md:items-center">
            <Avatar className="size-24 border-4 border-white shadow-lg">
              <AvatarImage src={user.avatar} />
              <AvatarFallback className="text-2xl">{user.name.charAt(0)}</AvatarFallback>
            </Avatar>
            
            <div className="flex-1">
              <h1 className="text-3xl mb-2 text-gray-900">{user.name}</h1>
              
              <div className="space-y-2 mb-4">
                <div className="flex items-center gap-2 text-gray-600">
                  <Building2 className="size-4" />
                  <span>{user.college}</span>
                </div>
                <div className="flex items-center gap-2 text-gray-600">
                  <BookOpen className="size-4" />
                  <span>{user.department}</span>
                </div>
                <div className="flex items-center gap-2 text-gray-600">
                  <Mail className="size-4" />
                  <span>{user.email}</span>
                </div>
              </div>

              <div className="flex flex-wrap gap-2">
                {user.skills.map((skill, index) => (
                  <Badge 
                    key={index} 
                    variant="outline"
                    className="bg-indigo-50 text-indigo-700 border-indigo-200"
                  >
                    {skill}
                  </Badge>
                ))}
              </div>
            </div>

            {isOwnProfile && onUploadClick && (
              <Button 
                onClick={onUploadClick}
                className="bg-indigo-600 hover:bg-indigo-700"
              >
                Upload Project
              </Button>
            )}
            
            {!isOwnProfile && onMessageClick && (
              <Button 
                onClick={() => onMessageClick(user.id)}
                className="bg-indigo-600 hover:bg-indigo-700 flex items-center gap-2"
              >
                <MessageSquare className="size-4" />
                Message
              </Button>
            )}
          </div>

          <Separator className="my-6" />

          {/* Stats */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
            <div className="text-center">
              <div className="text-2xl text-gray-900 mb-1">{userProjects.length}</div>
              <div className="text-sm text-gray-600">Total Projects</div>
            </div>
            <div className="text-center">
              <div className="text-2xl text-gray-900 mb-1">{patentProjects.length}</div>
              <div className="text-sm text-gray-600">Patents</div>
            </div>
            <div className="text-center">
              <div className="text-2xl text-gray-900 mb-1">{totalLikes}</div>
              <div className="text-sm text-gray-600">Total Likes</div>
            </div>
            <div className="text-center">
              <div className="text-2xl text-gray-900 mb-1">{hackathonProjects.length}</div>
              <div className="text-sm text-gray-600">Hackathon Wins</div>
            </div>
          </div>
        </Card>

        {/* Projects Section */}
        <Tabs defaultValue="all" className="w-full">
          <TabsList className="mb-6 bg-white border border-gray-200">
            <TabsTrigger value="all" className="flex items-center gap-2">
              <FileText className="size-4" />
              All Projects ({userProjects.length})
            </TabsTrigger>
            <TabsTrigger value="patents" className="flex items-center gap-2">
              <Award className="size-4" />
              Patents ({patentProjects.length})
            </TabsTrigger>
            <TabsTrigger value="hackathons" className="flex items-center gap-2">
              <Trophy className="size-4" />
              Hackathons ({hackathonProjects.length})
            </TabsTrigger>
            <TabsTrigger value="academic" className="flex items-center gap-2">
              <BookOpen className="size-4" />
              Academic ({academicProjects.length})
            </TabsTrigger>
          </TabsList>

          <TabsContent value="all">
            {userProjects.length > 0 ? (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {userProjects.map((project) => (
                  <ProjectCard
                    key={project.id}
                    project={project}
                    onClick={() => onProjectClick(project.id)}
                  />
                ))}
              </div>
            ) : (
              <Card className="p-12 text-center border-gray-200">
                <p className="text-gray-600">No projects uploaded yet.</p>
              </Card>
            )}
          </TabsContent>

          <TabsContent value="patents">
            {patentProjects.length > 0 ? (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {patentProjects.map((project) => (
                  <ProjectCard
                    key={project.id}
                    project={project}
                    onClick={() => onProjectClick(project.id)}
                  />
                ))}
              </div>
            ) : (
              <Card className="p-12 text-center border-gray-200">
                <Award className="size-12 text-gray-300 mx-auto mb-3" />
                <p className="text-gray-600">No patent projects yet.</p>
              </Card>
            )}
          </TabsContent>

          <TabsContent value="hackathons">
            {hackathonProjects.length > 0 ? (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {hackathonProjects.map((project) => (
                  <ProjectCard
                    key={project.id}
                    project={project}
                    onClick={() => onProjectClick(project.id)}
                  />
                ))}
              </div>
            ) : (
              <Card className="p-12 text-center border-gray-200">
                <Trophy className="size-12 text-gray-300 mx-auto mb-3" />
                <p className="text-gray-600">No hackathon wins yet.</p>
              </Card>
            )}
          </TabsContent>

          <TabsContent value="academic">
            {academicProjects.length > 0 ? (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {academicProjects.map((project) => (
                  <ProjectCard
                    key={project.id}
                    project={project}
                    onClick={() => onProjectClick(project.id)}
                  />
                ))}
              </div>
            ) : (
              <Card className="p-12 text-center border-gray-200">
                <BookOpen className="size-12 text-gray-300 mx-auto mb-3" />
                <p className="text-gray-600">No academic projects yet.</p>
              </Card>
            )}
          </TabsContent>
        </Tabs>
      </main>
    </div>
  );
}