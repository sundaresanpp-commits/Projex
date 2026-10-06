// Mock data for the college project showcase platform

export interface User {
  id: string;
  name: string;
  email: string;
  college: string;
  department: string;
  skills: string[];
  avatar?: string;
}

export interface TeamMember {
  userId: string;
  name: string;
  role: 'lead' | 'member';
}

export interface Comment {
  id: string;
  userId: string;
  userName: string;
  userAvatar?: string;
  text: string;
  timestamp: Date;
}

export type ProjectSection = 'Patent Project' | 'Hackathon / Competition Winner' | 'Academic / Final Year Project';

export interface Project {
  id: string;
  title: string;
  thumbnail: string;
  section: ProjectSection;
  domain: string;
  college: string;
  mentorName: string;
  problemStatement: string;
  year: number;
  teamMembers: TeamMember[];
  likes: number;
  commentCount: number;
  comments: Comment[];
  uploadedBy: string;
  uploadedAt: Date;
}

// Mock users
export const mockUsers: User[] = [
  {
    id: '1',
    name: 'Priya Sharma',
    email: 'priya.sharma@college.edu',
    college: 'IIT Delhi',
    department: 'Computer Science',
    skills: ['AI/ML', 'Python', 'TensorFlow', 'React'],
    avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop'
  },
  {
    id: '2',
    name: 'Arjun Patel',
    email: 'arjun.patel@college.edu',
    college: 'BITS Pilani',
    department: 'Electronics',
    skills: ['IoT', 'Embedded Systems', 'Arduino', 'C++'],
    avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop'
  },
  {
    id: '3',
    name: 'Sneha Reddy',
    email: 'sneha.reddy@college.edu',
    college: 'NIT Trichy',
    department: 'Biotechnology',
    skills: ['Healthcare Tech', 'Data Analysis', 'Python', 'Research'],
    avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop'
  },
  {
    id: '4',
    name: 'Rahul Verma',
    email: 'rahul.verma@college.edu',
    college: 'IIT Bombay',
    department: 'Mechanical Engineering',
    skills: ['Robotics', 'CAD', 'Automation', 'Python'],
    avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop'
  },
  {
    id: '5',
    name: 'Ananya Singh',
    email: 'ananya.singh@college.edu',
    college: 'Delhi Technological University',
    department: 'Computer Science',
    skills: ['Web Development', 'Cloud Computing', 'DevOps', 'Kubernetes'],
    avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop'
  }
];

// Mock projects
export const mockProjects: Project[] = [
  {
    id: 'p1',
    title: 'AI-Powered Disease Diagnosis System',
    thumbnail: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=800&h=600&fit=crop',
    section: 'Patent Project',
    domain: 'AI, Healthcare',
    college: 'IIT Delhi',
    mentorName: 'Dr. Rajesh Kumar',
    problemStatement: 'Early detection of diseases using deep learning algorithms to analyze medical imaging data. The system can identify patterns in X-rays, CT scans, and MRI images to assist doctors in making faster and more accurate diagnoses.',
    year: 2024,
    teamMembers: [
      { userId: '1', name: 'Priya Sharma', role: 'lead' },
      { userId: '3', name: 'Sneha Reddy', role: 'member' }
    ],
    likes: 245,
    commentCount: 32,
    comments: [
      {
        id: 'c1',
        userId: '2',
        userName: 'Arjun Patel',
        userAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
        text: 'This is amazing work! What accuracy rates are you achieving?',
        timestamp: new Date('2024-01-15T10:30:00')
      },
      {
        id: 'c2',
        userId: '4',
        userName: 'Rahul Verma',
        userAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop',
        text: 'Great potential for real-world implementation. Have you considered integration with existing hospital systems?',
        timestamp: new Date('2024-01-16T14:20:00')
      }
    ],
    uploadedBy: '1',
    uploadedAt: new Date('2024-01-10T09:00:00')
  },
  {
    id: 'p2',
    title: 'Smart Campus Energy Management System',
    thumbnail: 'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?w=800&h=600&fit=crop',
    section: 'Hackathon / Competition Winner',
    domain: 'IoT, Sustainability',
    college: 'BITS Pilani',
    mentorName: 'Prof. Meera Joshi',
    problemStatement: 'An IoT-based solution to monitor and optimize energy consumption across campus buildings, reducing wastage and carbon footprint through real-time monitoring and automated controls.',
    year: 2024,
    teamMembers: [
      { userId: '2', name: 'Arjun Patel', role: 'lead' },
      { userId: '5', name: 'Ananya Singh', role: 'member' }
    ],
    likes: 198,
    commentCount: 28,
    comments: [
      {
        id: 'c3',
        userId: '1',
        userName: 'Priya Sharma',
        userAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop',
        text: 'Won Smart India Hackathon? Congratulations! 🎉',
        timestamp: new Date('2024-01-20T11:45:00')
      }
    ],
    uploadedBy: '2',
    uploadedAt: new Date('2024-01-18T15:30:00')
  },
  {
    id: 'p3',
    title: 'Blockchain-Based Academic Credential Verification',
    thumbnail: 'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=800&h=600&fit=crop',
    section: 'Academic / Final Year Project',
    domain: 'Blockchain, Education',
    college: 'NIT Trichy',
    mentorName: 'Dr. Anil Gupta',
    problemStatement: 'A decentralized platform for storing and verifying academic credentials using blockchain technology, preventing certificate fraud and enabling instant verification by employers.',
    year: 2025,
    teamMembers: [
      { userId: '3', name: 'Sneha Reddy', role: 'lead' },
      { userId: '1', name: 'Priya Sharma', role: 'member' },
      { userId: '5', name: 'Ananya Singh', role: 'member' }
    ],
    likes: 176,
    commentCount: 19,
    comments: [],
    uploadedBy: '3',
    uploadedAt: new Date('2024-01-22T08:15:00')
  },
  {
    id: 'p4',
    title: 'Autonomous Delivery Robot for Campus',
    thumbnail: 'https://images.unsplash.com/photo-1563207153-f403bf289096?w=800&h=600&fit=crop',
    section: 'Hackathon / Competition Winner',
    domain: 'Robotics, AI',
    college: 'IIT Bombay',
    mentorName: 'Prof. Sanjay Desai',
    problemStatement: 'An autonomous robot capable of delivering food, books, and packages across campus using computer vision, path planning algorithms, and obstacle avoidance technology.',
    year: 2024,
    teamMembers: [
      { userId: '4', name: 'Rahul Verma', role: 'lead' },
      { userId: '2', name: 'Arjun Patel', role: 'member' }
    ],
    likes: 312,
    commentCount: 45,
    comments: [
      {
        id: 'c4',
        userId: '5',
        userName: 'Ananya Singh',
        userAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop',
        text: 'This could revolutionize campus logistics! What\'s the battery life?',
        timestamp: new Date('2024-01-25T16:00:00')
      }
    ],
    uploadedBy: '4',
    uploadedAt: new Date('2024-01-24T12:00:00')
  },
  {
    id: 'p5',
    title: 'Mental Health Support Chatbot',
    thumbnail: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=800&h=600&fit=crop',
    section: 'Academic / Final Year Project',
    domain: 'AI, Healthcare, NLP',
    college: 'Delhi Technological University',
    mentorName: 'Dr. Kavita Sharma',
    problemStatement: 'An AI-powered chatbot providing 24/7 mental health support to students using natural language processing and sentiment analysis, offering coping strategies and crisis intervention.',
    year: 2025,
    teamMembers: [
      { userId: '5', name: 'Ananya Singh', role: 'lead' }
    ],
    likes: 203,
    commentCount: 34,
    comments: [
      {
        id: 'c5',
        userId: '3',
        userName: 'Sneha Reddy',
        userAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop',
        text: 'Very important work! Is it being deployed at your university?',
        timestamp: new Date('2024-01-28T09:30:00')
      }
    ],
    uploadedBy: '5',
    uploadedAt: new Date('2024-01-26T10:45:00')
  },
  {
    id: 'p6',
    title: 'Smart Waste Segregation System',
    thumbnail: 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800&h=600&fit=crop',
    section: 'Patent Project',
    domain: 'IoT, Sustainability, AI',
    college: 'IIT Delhi',
    mentorName: 'Prof. Ramesh Iyer',
    problemStatement: 'An automated waste segregation system using computer vision and robotics to identify and separate biodegradable, recyclable, and hazardous waste, improving recycling efficiency.',
    year: 2024,
    teamMembers: [
      { userId: '1', name: 'Priya Sharma', role: 'lead' },
      { userId: '4', name: 'Rahul Verma', role: 'member' }
    ],
    likes: 167,
    commentCount: 22,
    comments: [],
    uploadedBy: '1',
    uploadedAt: new Date('2024-01-29T14:00:00')
  },
  {
    id: 'p7',
    title: 'Real-time Air Quality Monitoring Network',
    thumbnail: 'https://images.unsplash.com/photo-1611273426858-450d8e3c9fce?w=800&h=600&fit=crop',
    section: 'Academic / Final Year Project',
    domain: 'IoT, Environment',
    college: 'BITS Pilani',
    mentorName: 'Dr. Sunita Agarwal',
    problemStatement: 'A distributed sensor network for monitoring air quality parameters across the city, providing real-time data visualization and alerts to citizens and policymakers.',
    year: 2025,
    teamMembers: [
      { userId: '2', name: 'Arjun Patel', role: 'lead' },
      { userId: '3', name: 'Sneha Reddy', role: 'member' }
    ],
    likes: 142,
    commentCount: 18,
    comments: [],
    uploadedBy: '2',
    uploadedAt: new Date('2024-01-30T11:20:00')
  }
];

// Helper function to get user by ID
export const getUserById = (userId: string): User | undefined => {
  return mockUsers.find(user => user.id === userId);
};

// Helper function to get projects by user ID
export const getProjectsByUserId = (userId: string): Project[] => {
  return mockProjects.filter(project => 
    project.uploadedBy === userId || 
    project.teamMembers.some(member => member.userId === userId)
  );
};

// Helper function to search projects
export const searchProjects = (query: string): Project[] => {
  const lowerQuery = query.toLowerCase();
  return mockProjects.filter(project => 
    project.title.toLowerCase().includes(lowerQuery) ||
    project.domain.toLowerCase().includes(lowerQuery) ||
    project.problemStatement.toLowerCase().includes(lowerQuery)
  );
};

// Currently logged in user (for demo purposes)
export const currentUser = mockUsers[0];
