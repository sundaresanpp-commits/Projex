import { Heart, MessageCircle, Award, FileText, Trophy } from 'lucide-react';
import { Badge } from '@/app/components/ui/badge';
import { Card } from '@/app/components/ui/card';
import { Project } from '@/app/data/mockData';
import { useState } from 'react';

interface ProjectCardProps {
  project: Project;
  onClick: () => void;
}

export function ProjectCard({ project, onClick }: ProjectCardProps) {
  const [liked, setLiked] = useState(false);
  const [likeCount, setLikeCount] = useState(project.likes);

  const handleLike = (e: React.MouseEvent) => {
    e.stopPropagation();
    if (liked) {
      setLikeCount(likeCount - 1);
    } else {
      setLikeCount(likeCount + 1);
    }
    setLiked(!liked);
  };

  const getSectionIcon = () => {
    switch (project.section) {
      case 'Patent Project':
        return <Award className="size-4" />;
      case 'Hackathon / Competition Winner':
        return <Trophy className="size-4" />;
      case 'Academic / Final Year Project':
        return <FileText className="size-4" />;
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

  return (
    <Card 
      className="overflow-hidden cursor-pointer hover:shadow-lg transition-shadow bg-white border border-gray-200"
      onClick={onClick}
    >
      {/* Project Image */}
      <div className="aspect-[4/3] overflow-hidden bg-gray-100">
        <img
          src={project.thumbnail}
          alt={project.title}
          className="w-full h-full object-cover hover:scale-105 transition-transform duration-300"
        />
      </div>

      {/* Project Info */}
      <div className="p-4">
        {/* Section and Domain Tags */}
        <div className="flex flex-wrap gap-2 mb-3">
          <Badge 
            variant="outline" 
            className={`${getSectionColor()} flex items-center gap-1`}
          >
            {getSectionIcon()}
            {project.section}
          </Badge>
          <Badge variant="outline" className="bg-gray-50 text-gray-700 border-gray-200">
            {project.domain}
          </Badge>
        </div>

        {/* Title */}
        <h3 className="text-lg mb-2 text-gray-900 line-clamp-2">
          {project.title}
        </h3>

        {/* College and Mentor */}
        <div className="space-y-1 mb-3">
          <p className="text-sm text-gray-600">
            <span className="text-gray-900">{project.college}</span>
          </p>
          <p className="text-sm text-gray-600">
            Mentor: <span className="text-gray-900">{project.mentorName}</span>
          </p>
        </div>

        {/* Like and Comment Actions */}
        <div className="flex items-center gap-4 pt-3 border-t border-gray-100">
          <button
            onClick={handleLike}
            className="flex items-center gap-2 text-gray-600 hover:text-red-600 transition-colors"
          >
            <Heart 
              className={`size-5 ${liked ? 'fill-red-600 text-red-600' : ''}`} 
            />
            <span className="text-sm">{likeCount}</span>
          </button>
          <div className="flex items-center gap-2 text-gray-600">
            <MessageCircle className="size-5" />
            <span className="text-sm">{project.commentCount}</span>
          </div>
        </div>
      </div>
    </Card>
  );
}
