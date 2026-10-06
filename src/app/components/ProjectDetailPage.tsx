import { useState } from 'react';
import { ArrowLeft, Heart, MessageCircle, Award, Trophy, FileText, Calendar, Building2, UserCheck, Send } from 'lucide-react';
import { Button } from '@/app/components/ui/button';
import { Badge } from '@/app/components/ui/badge';
import { Card } from '@/app/components/ui/card';
import { Textarea } from '@/app/components/ui/textarea';
import { Avatar, AvatarFallback, AvatarImage } from '@/app/components/ui/avatar';
import { Separator } from '@/app/components/ui/separator';
import { Project, getUserById, currentUser } from '@/app/data/mockData';

interface ProjectDetailPageProps {
  project: Project;
  onBack: () => void;
  onUserClick: (userId: string) => void;
}

export function ProjectDetailPage({ project, onBack, onUserClick }: ProjectDetailPageProps) {
  const [liked, setLiked] = useState(false);
  const [likeCount, setLikeCount] = useState(project.likes);
  const [comments, setComments] = useState(project.comments);
  const [newComment, setNewComment] = useState('');

  const handleLike = () => {
    if (liked) {
      setLikeCount(likeCount - 1);
    } else {
      setLikeCount(likeCount + 1);
    }
    setLiked(!liked);
  };

  const handleAddComment = () => {
    if (newComment.trim()) {
      const comment = {
        id: `c${Date.now()}`,
        userId: currentUser.id,
        userName: currentUser.name,
        userAvatar: currentUser.avatar,
        text: newComment,
        timestamp: new Date()
      };
      setComments([...comments, comment]);
      setNewComment('');
    }
  };

  const getSectionIcon = () => {
    switch (project.section) {
      case 'Patent Project':
        return <Award className="size-5" />;
      case 'Hackathon / Competition Winner':
        return <Trophy className="size-5" />;
      case 'Academic / Final Year Project':
        return <FileText className="size-5" />;
    }
  };

  const getSectionColor = () => {
    switch (project.section) {
      case 'Patent Project':
        return 'bg-amber-50 text-amber-700 border-amber-200';
      case 'Hackathon / Competition Winner':
        return 'bg-purple-50 text-purple-700 border-purple-200';
      case 'Academic / Final Year Project':
        return 'bg-blue-50 text-blue-700 border-blue-200';
    }
  };

  const projectLead = project.teamMembers.find(m => m.role === 'lead');

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200 sticky top-0 z-10 shadow-sm">
        <div className="max-w-5xl mx-auto px-4 py-4">
          <Button 
            variant="ghost" 
            onClick={onBack}
            className="flex items-center gap-2 text-gray-600 hover:text-gray-900"
          >
            <ArrowLeft className="size-4" />
            Back to Feed
          </Button>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-5xl mx-auto px-4 py-8">
        <div className="grid lg:grid-cols-3 gap-6">
          {/* Left Column - Project Details */}
          <div className="lg:col-span-2 space-y-6">
            {/* Project Image */}
            <Card className="overflow-hidden border-gray-200">
              <div className="aspect-[16/10] overflow-hidden bg-gray-100">
                <img
                  src={project.thumbnail}
                  alt={project.title}
                  className="w-full h-full object-cover"
                />
              </div>
            </Card>

            {/* Project Info */}
            <Card className="p-6 border-gray-200">
              <div className="flex flex-wrap gap-2 mb-4">
                <Badge 
                  variant="outline" 
                  className={`${getSectionColor()} flex items-center gap-1.5`}
                >
                  {getSectionIcon()}
                  {project.section}
                </Badge>
                <Badge variant="outline" className="bg-gray-50 text-gray-700 border-gray-200">
                  {project.domain}
                </Badge>
              </div>

              <h1 className="text-3xl mb-4 text-gray-900">
                {project.title}
              </h1>

              <div className="flex items-center gap-6 mb-6 text-sm text-gray-600">
                <div className="flex items-center gap-2">
                  <Calendar className="size-4" />
                  <span>{project.year}</span>
                </div>
                <div className="flex items-center gap-2">
                  <Building2 className="size-4" />
                  <span>{project.college}</span>
                </div>
              </div>

              <Separator className="my-6" />

              <div>
                <h2 className="text-lg mb-3 text-gray-900">Problem Statement</h2>
                <p className="text-gray-700 leading-relaxed">
                  {project.problemStatement}
                </p>
              </div>

              <Separator className="my-6" />

              <div>
                <h2 className="text-lg mb-3 text-gray-900">Mentor</h2>
                <div className="flex items-center gap-2 text-gray-700">
                  <UserCheck className="size-5 text-indigo-600" />
                  <span>{project.mentorName}</span>
                </div>
              </div>
            </Card>

            {/* Engagement Actions */}
            <Card className="p-4 border-gray-200">
              <div className="flex items-center gap-6">
                <Button
                  variant={liked ? "default" : "outline"}
                  onClick={handleLike}
                  className={`flex items-center gap-2 ${liked ? 'bg-red-600 hover:bg-red-700' : 'border-gray-200'}`}
                >
                  <Heart className={`size-5 ${liked ? 'fill-white' : ''}`} />
                  <span>{likeCount} Likes</span>
                </Button>
                <div className="flex items-center gap-2 text-gray-600">
                  <MessageCircle className="size-5" />
                  <span>{comments.length} Comments</span>
                </div>
              </div>
            </Card>

            {/* Comments Section */}
            <Card className="p-6 border-gray-200">
              <h2 className="text-lg mb-4 text-gray-900">Comments</h2>

              {/* Add Comment */}
              <div className="mb-6">
                <div className="flex gap-3">
                  <Avatar className="size-10">
                    <AvatarImage src={currentUser.avatar} />
                    <AvatarFallback>{currentUser.name.charAt(0)}</AvatarFallback>
                  </Avatar>
                  <div className="flex-1">
                    <Textarea
                      placeholder="Share your thoughts..."
                      value={newComment}
                      onChange={(e) => setNewComment(e.target.value)}
                      className="mb-2 border-gray-200"
                    />
                    <Button 
                      onClick={handleAddComment}
                      disabled={!newComment.trim()}
                      className="bg-indigo-600 hover:bg-indigo-700"
                    >
                      <Send className="size-4 mr-2" />
                      Post Comment
                    </Button>
                  </div>
                </div>
              </div>

              {/* Comments List */}
              <div className="space-y-4">
                {comments.length === 0 ? (
                  <p className="text-gray-500 text-center py-8">
                    No comments yet. Be the first to comment!
                  </p>
                ) : (
                  comments.map((comment) => (
                    <div key={comment.id} className="flex gap-3">
                      <Avatar className="size-10">
                        <AvatarImage src={comment.userAvatar} />
                        <AvatarFallback>{comment.userName.charAt(0)}</AvatarFallback>
                      </Avatar>
                      <div className="flex-1">
                        <div className="bg-gray-50 rounded-lg p-3 border border-gray-100">
                          <button
                            onClick={() => onUserClick(comment.userId)}
                            className="text-gray-900 hover:text-indigo-600 mb-1"
                          >
                            {comment.userName}
                          </button>
                          <p className="text-gray-700">{comment.text}</p>
                        </div>
                        <p className="text-xs text-gray-500 mt-1 ml-3">
                          {comment.timestamp.toLocaleDateString()} at {comment.timestamp.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                        </p>
                      </div>
                    </div>
                  ))
                )}
              </div>
            </Card>
          </div>

          {/* Right Column - Team Info */}
          <div className="space-y-6">
            <Card className="p-6 border-gray-200">
              <h2 className="text-lg mb-4 text-gray-900">Team Members</h2>
              
              <div className="space-y-3">
                {project.teamMembers.map((member) => {
                  const user = getUserById(member.userId);
                  if (!user) return null;

                  return (
                    <button
                      key={member.userId}
                      onClick={() => onUserClick(member.userId)}
                      className="w-full flex items-center gap-3 p-3 rounded-lg hover:bg-gray-50 transition-colors text-left border border-gray-100"
                    >
                      <Avatar className="size-12">
                        <AvatarImage src={user.avatar} />
                        <AvatarFallback>{user.name.charAt(0)}</AvatarFallback>
                      </Avatar>
                      <div className="flex-1">
                        <p className="text-gray-900">{user.name}</p>
                        <p className="text-sm text-gray-600">
                          {member.role === 'lead' ? (
                            <span className="flex items-center gap-1 text-indigo-600">
                              <Award className="size-3" />
                              Project Lead
                            </span>
                          ) : (
                            'Team Member'
                          )}
                        </p>
                      </div>
                    </button>
                  );
                })}
              </div>
            </Card>

            {/* Quick Stats */}
            <Card className="p-6 border-gray-200">
              <h2 className="text-lg mb-4 text-gray-900">Project Stats</h2>
              <div className="space-y-3">
                <div className="flex justify-between items-center">
                  <span className="text-gray-600">Total Likes</span>
                  <span className="text-gray-900">{likeCount}</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-gray-600">Comments</span>
                  <span className="text-gray-900">{comments.length}</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-gray-600">Team Size</span>
                  <span className="text-gray-900">{project.teamMembers.length}</span>
                </div>
              </div>
            </Card>
          </div>
        </div>
      </main>
    </div>
  );
}
