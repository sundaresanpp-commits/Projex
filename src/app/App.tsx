import { useState } from 'react';
import { LoginPage } from '@/app/components/LoginPage';
import { HomePage } from '@/app/components/HomePage';
import { ProjectDetailPage } from '@/app/components/ProjectDetailPage';
import { ProfilePage } from '@/app/components/ProfilePage';
import { UploadProjectPage } from '@/app/components/UploadProjectPage';
import { MessagesPage } from '@/app/components/MessagesPage';
import { mockProjects, getUserById, currentUser } from '@/app/data/mockData';
import { Toaster } from '@/app/components/ui/sonner';
import { toast } from 'sonner';

type Page = 
  | { type: 'login' }
  | { type: 'home' }
  | { type: 'project-detail'; projectId: string }
  | { type: 'profile'; userId: string }
  | { type: 'upload' }
  | { type: 'messages'; selectedUserId?: string };

export default function App() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [currentPage, setCurrentPage] = useState<Page>({ type: 'login' });
  const [loggedInUser, setLoggedInUser] = useState(currentUser);

  const handleLogin = (userData: { name: string; email: string; college: string; department: string }) => {
    // Update the logged-in user with registration data
    const updatedUser = {
      ...currentUser,
      name: userData.name,
      email: userData.email,
      college: userData.college,
      department: userData.department
    };
    
    setLoggedInUser(updatedUser);
    setIsAuthenticated(true);
    setCurrentPage({ type: 'home' });
    toast.success(`Welcome, ${userData.name}! 🎓`);
  };

  const handleLogout = () => {
    setIsAuthenticated(false);
    setCurrentPage({ type: 'login' });
    toast.success('Logged out successfully');
  };

  const navigateToHome = () => {
    setCurrentPage({ type: 'home' });
  };

  const navigateToProject = (projectId: string) => {
    setCurrentPage({ type: 'project-detail', projectId });
  };

  const navigateToProfile = (userId: string) => {
    setCurrentPage({ type: 'profile', userId });
  };

  const navigateToUpload = () => {
    setCurrentPage({ type: 'upload' });
  };

  const navigateToMessages = (selectedUserId?: string) => {
    setCurrentPage({ type: 'messages', selectedUserId });
  };

  const handleUploadSuccess = () => {
    setCurrentPage({ type: 'home' });
    toast.success('Project uploaded successfully! 🎉');
  };

  const handleMessageUser = (userId: string) => {
    navigateToMessages(userId);
  };

  // Not authenticated - show login
  if (!isAuthenticated) {
    return (
      <>
        <LoginPage onLogin={handleLogin} />
        <Toaster position="top-center" />
      </>
    );
  }

  // Authenticated - show appropriate page
  return (
    <>
      {currentPage.type === 'home' && (
        <HomePage
          onProjectClick={navigateToProject}
          onProfileClick={navigateToProfile}
          onUploadClick={navigateToUpload}
          onMessagesClick={() => navigateToMessages()}
          onLogout={handleLogout}
        />
      )}

      {currentPage.type === 'project-detail' && (
        <>
          {(() => {
            const project = mockProjects.find(p => p.id === currentPage.projectId);
            if (!project) {
              navigateToHome();
              return null;
            }
            return (
              <ProjectDetailPage
                project={project}
                onBack={navigateToHome}
                onUserClick={navigateToProfile}
              />
            );
          })()}
        </>
      )}

      {currentPage.type === 'profile' && (
        <>
          {(() => {
            const user = getUserById(currentPage.userId);
            if (!user) {
              navigateToHome();
              return null;
            }
            return (
              <ProfilePage
                user={user}
                onBack={navigateToHome}
                onProjectClick={navigateToProject}
                onUploadClick={navigateToUpload}
                onMessageClick={handleMessageUser}
                isOwnProfile={user.id === loggedInUser.id}
              />
            );
          })()}
        </>
      )}

      {currentPage.type === 'upload' && (
        <UploadProjectPage
          onBack={navigateToHome}
          onSubmit={handleUploadSuccess}
        />
      )}

      {currentPage.type === 'messages' && (
        <MessagesPage
          onBack={navigateToHome}
          onUserClick={navigateToProfile}
          selectedUserId={currentPage.selectedUserId}
        />
      )}

      <Toaster position="top-center" />
    </>
  );
}