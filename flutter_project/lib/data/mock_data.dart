import '../models/models.dart';

final User currentUser = User(
  id: 'u1',
  name: 'Arjun Sharma',
  email: 'arjun.sharma@iit.ac.in',
  college: 'IIT Bombay',
  department: 'Computer Science',
  year: '4th Year',
  bio:
      'Full-stack developer passionate about AI/ML and building scalable systems. Looking for SDE roles.',
  skills: ['Flutter', 'React', 'Python', 'TensorFlow', 'Node.js'],
  projectCount: 5,
  followers: 128,
  following: 64,
);

final List<User> mockUsers = [
  currentUser,
  const User(
    id: 'u2',
    name: 'Priya Patel',
    email: 'priya.patel@nit.ac.in',
    college: 'NIT Surat',
    department: 'Electronics',
    year: '3rd Year',
    bio: 'IoT & Embedded Systems enthusiast. Patent holder.',
    skills: ['Arduino', 'Python', 'C++', 'IoT'],
    projectCount: 3,
    followers: 89,
    following: 42,
  ),
  const User(
    id: 'u3',
    name: 'Rahul Verma',
    email: 'rahul.verma@bits.ac.in',
    college: 'BITS Pilani',
    department: 'Mechanical',
    year: '4th Year',
    bio: 'Robotics and automation. Smart India Hackathon finalist.',
    skills: ['ROS', 'Python', 'SolidWorks', 'MATLAB'],
    projectCount: 4,
    followers: 156,
    following: 78,
  ),
  const User(
    id: 'u4',
    name: 'Sneha Reddy',
    email: 'sneha.reddy@vit.ac.in',
    college: 'VIT Vellore',
    department: 'Computer Science',
    year: '2nd Year',
    bio: 'AI/ML researcher focused on NLP and computer vision.',
    skills: ['PyTorch', 'NLP', 'Computer Vision', 'Python'],
    projectCount: 2,
    followers: 67,
    following: 33,
  ),
];

List<Project> mockProjects = [
  Project(
    id: 'p1',
    title: 'AI-Powered Crop Disease Detection System',
    description:
        'A machine learning model that detects crop diseases from smartphone images with 94% accuracy. Uses CNN architecture trained on 50,000+ agricultural images. Deployed as a mobile app helping 2000+ farmers. Integrated IoT sensors for real-time soil monitoring and automated irrigation alerts.',
    section: ProjectSection.hackathon,
    domain: 'AI/ML',
    college: 'IIT Bombay',
    mentorName: 'Dr. Rakesh Gupta',
    teamMembers: [
      TeamMember(userId: 'u1', name: 'Arjun Sharma', role: 'ML Engineer'),
      TeamMember(userId: 'u2', name: 'Priya Patel', role: 'Backend Dev'),
      TeamMember(userId: 'u4', name: 'Sneha Reddy', role: 'Data Scientist'),
    ],
    thumbnailUrl:
        'https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=600',
    likes: 247,
    comments: 38,
    views: 1240,
    createdAt: DateTime(2024, 3, 15),
    authorId: 'u1',
    authorName: 'Arjun Sharma',
    tags: ['Smart India Hackathon', 'Winner', 'Agriculture', 'CNN'],
    githubUrl: 'https://github.com/example/crop-disease',
    demoUrl: 'https://demo.example.com',
    isLiked: true,
  ),
  Project(
    id: 'p2',
    title: 'Smart Helmet with Accident Detection & Emergency Alert',
    description:
        'An IoT-enabled helmet with accelerometer and gyroscope sensors that detects accidents in real-time. Automatically alerts emergency contacts with GPS location via SMS. Patent filed for the multi-sensor fusion algorithm. Passed 200+ crash simulations.',
    section: ProjectSection.patent,
    domain: 'IoT',
    college: 'NIT Surat',
    mentorName: 'Prof. Meena Shah',
    teamMembers: [
      TeamMember(userId: 'u2', name: 'Priya Patel', role: 'Hardware Lead'),
      TeamMember(userId: 'u3', name: 'Rahul Verma', role: 'Embedded Systems'),
    ],
    thumbnailUrl:
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600',
    likes: 189,
    comments: 24,
    views: 892,
    createdAt: DateTime(2024, 2, 20),
    authorId: 'u2',
    authorName: 'Priya Patel',
    tags: ['Patent', 'IoT', 'Safety', 'GPS'],
    githubUrl: 'https://github.com/example/smart-helmet',
  ),
  Project(
    id: 'p3',
    title: 'Autonomous Warehouse Robot Navigation System',
    description:
        'A ROS-based autonomous robot that navigates warehouse environments using SLAM (Simultaneous Localization and Mapping). Achieves 99.2% path accuracy and handles dynamic obstacles. Final year B.Tech project at BITS Pilani with industry collaboration.',
    section: ProjectSection.academic,
    domain: 'Robotics',
    college: 'BITS Pilani',
    mentorName: 'Dr. Arun Kumar',
    teamMembers: [
      TeamMember(userId: 'u3', name: 'Rahul Verma', role: 'Robotics Lead'),
      TeamMember(userId: 'u1', name: 'Arjun Sharma', role: 'Software Dev'),
    ],
    thumbnailUrl:
        'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=600',
    likes: 312,
    comments: 47,
    views: 1580,
    createdAt: DateTime(2024, 4, 5),
    authorId: 'u3',
    authorName: 'Rahul Verma',
    tags: ['ROS', 'SLAM', 'Final Year', 'Robotics'],
    githubUrl: 'https://github.com/example/warehouse-robot',
  ),
  Project(
    id: 'p4',
    title: 'Deepfake Detection Using Transformer Architecture',
    description:
        'A novel approach to deepfake detection using Vision Transformers (ViT) achieving 96.7% accuracy on FaceForensics++ dataset. Presented at national ML conference. Addresses ethical concerns in digital media.',
    section: ProjectSection.hackathon,
    domain: 'AI/ML',
    college: 'VIT Vellore',
    mentorName: 'Dr. Lakshmi Prasad',
    teamMembers: [
      TeamMember(userId: 'u4', name: 'Sneha Reddy', role: 'ML Researcher'),
    ],
    thumbnailUrl:
        'https://images.unsplash.com/photo-1677442135703-1787eea5ce01?w=600',
    likes: 423,
    comments: 61,
    views: 2100,
    createdAt: DateTime(2024, 1, 12),
    authorId: 'u4',
    authorName: 'Sneha Reddy',
    tags: ['Vision Transformer', 'Deepfake', 'Computer Vision', 'Winner'],
  ),
  Project(
    id: 'p5',
    title: 'Blockchain-Based Academic Credential Verification',
    description:
        'A decentralized system for issuing and verifying academic certificates using Ethereum smart contracts. Eliminates certificate fraud and enables instant global verification. Pilot deployed at 3 universities.',
    section: ProjectSection.patent,
    domain: 'Blockchain',
    college: 'IIT Bombay',
    mentorName: 'Prof. Vijay Sharma',
    teamMembers: [
      TeamMember(userId: 'u1', name: 'Arjun Sharma', role: 'Blockchain Dev'),
      TeamMember(userId: 'u4', name: 'Sneha Reddy', role: 'Smart Contracts'),
    ],
    thumbnailUrl:
        'https://images.unsplash.com/photo-1639762681485-074b7f938ba0?w=600',
    likes: 278,
    comments: 35,
    views: 1320,
    createdAt: DateTime(2024, 3, 28),
    authorId: 'u1',
    authorName: 'Arjun Sharma',
    tags: ['Blockchain', 'Ethereum', 'Patent', 'EdTech'],
  ),
  Project(
    id: 'p6',
    title: 'Real-Time Sign Language to Text Converter',
    description:
        'Uses MediaPipe hand tracking and LSTM networks to convert sign language gestures to text in real-time. Supports 500+ Indian Sign Language gestures. Runs on mobile with 30fps performance.',
    section: ProjectSection.academic,
    domain: 'Computer Vision',
    college: 'NIT Surat',
    mentorName: 'Dr. Kamal Bansal',
    teamMembers: [
      TeamMember(userId: 'u2', name: 'Priya Patel', role: 'CV Engineer'),
      TeamMember(userId: 'u3', name: 'Rahul Verma', role: 'Mobile Dev'),
    ],
    thumbnailUrl:
        'https://images.unsplash.com/photo-1509048191080-d2984bad6ae5?w=600',
    likes: 367,
    comments: 52,
    views: 1870,
    createdAt: DateTime(2024, 2, 14),
    authorId: 'u2',
    authorName: 'Priya Patel',
    tags: ['MediaPipe', 'LSTM', 'Accessibility', 'ISL'],
  ),
];

List<Comment> mockComments = [
  Comment(
    id: 'c1',
    authorId: 'u2',
    authorName: 'Priya Patel',
    content:
        'Amazing work! The accuracy rate is impressive. How did you handle class imbalance in the dataset?',
    createdAt: DateTime(2024, 3, 16),
  ),
  Comment(
    id: 'c2',
    authorId: 'u3',
    authorName: 'Rahul Verma',
    content:
        'This is exactly what farmers in rural areas need. Great application of ML!',
    createdAt: DateTime(2024, 3, 17),
  ),
  Comment(
    id: 'c3',
    authorId: 'u4',
    authorName: 'Sneha Reddy',
    content:
        'Would love to collaborate on extending this to more crop varieties. DM me!',
    createdAt: DateTime(2024, 3, 18),
  ),
];

List<Conversation> mockConversations = [
  Conversation(
    id: 'conv1',
    otherUser: mockUsers[1],
    lastMessage: Message(
      id: 'm1',
      senderId: 'u2',
      receiverId: 'u1',
      content: 'Hey! Would love to collaborate on your crop disease project.',
      timestamp: DateTime(2024, 4, 10, 14, 30),
      status: MessageStatus.read,
    ),
    unreadCount: 0,
  ),
  Conversation(
    id: 'conv2',
    otherUser: mockUsers[2],
    lastMessage: Message(
      id: 'm2',
      senderId: 'u1',
      receiverId: 'u3',
      content:
          "Great robotics project! How did you implement the SLAM algorithm?",
      timestamp: DateTime(2024, 4, 9, 10, 15),
      status: MessageStatus.delivered,
    ),
    unreadCount: 2,
  ),
  Conversation(
    id: 'conv3',
    otherUser: mockUsers[3],
    lastMessage: Message(
      id: 'm3',
      senderId: 'u4',
      receiverId: 'u1',
      content: "Check out my new deepfake detection results!",
      timestamp: DateTime(2024, 4, 8, 18, 45),
      status: MessageStatus.read,
    ),
    unreadCount: 1,
  ),
];

Map<String, List<Message>> mockMessages = {
  'conv1': [
    Message(
      id: 'm1a',
      senderId: 'u2',
      receiverId: 'u1',
      content:
          'Hey Arjun! I saw your crop disease detection project. Really impressive work!',
      timestamp: DateTime(2024, 4, 10, 14, 0),
      status: MessageStatus.read,
    ),
    Message(
      id: 'm1b',
      senderId: 'u1',
      receiverId: 'u2',
      content: "Thanks Priya! It was a challenging but rewarding project.",
      timestamp: DateTime(2024, 4, 10, 14, 15),
      status: MessageStatus.read,
    ),
    Message(
      id: 'm1c',
      senderId: 'u2',
      receiverId: 'u1',
      content:
          "Would love to collaborate on extending it to more crops. I have experience with IoT sensors for soil data.",
      timestamp: DateTime(2024, 4, 10, 14, 30),
      status: MessageStatus.read,
    ),
  ],
  'conv2': [
    Message(
      id: 'm2a',
      senderId: 'u3',
      receiverId: 'u1',
      content: "Hi! Your blockchain credential project is fascinating.",
      timestamp: DateTime(2024, 4, 9, 9, 30),
      status: MessageStatus.read,
    ),
    Message(
      id: 'm2b',
      senderId: 'u1',
      receiverId: 'u3',
      content:
          "Great robotics project! How did you implement the SLAM algorithm?",
      timestamp: DateTime(2024, 4, 9, 10, 15),
      status: MessageStatus.delivered,
    ),
  ],
  'conv3': [
    Message(
      id: 'm3a',
      senderId: 'u4',
      receiverId: 'u1',
      content: "Check out my new deepfake detection results! 96.7% accuracy!",
      timestamp: DateTime(2024, 4, 8, 18, 45),
      status: MessageStatus.read,
    ),
  ],
};
