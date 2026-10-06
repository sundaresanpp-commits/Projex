// Mock data for messaging system

export interface Message {
  id: string;
  conversationId: string;
  senderId: string;
  receiverId: string;
  text: string;
  timestamp: Date;
  read: boolean;
}

export interface Conversation {
  id: string;
  participantIds: string[];
  lastMessage: Message;
  unreadCount: number;
}

// Mock messages
export const mockMessages: Message[] = [
  {
    id: 'm1',
    conversationId: 'c1',
    senderId: '2',
    receiverId: '1',
    text: 'Hi Priya! I saw your AI Disease Diagnosis project. Very impressive work!',
    timestamp: new Date('2024-01-28T10:30:00'),
    read: true
  },
  {
    id: 'm2',
    conversationId: 'c1',
    senderId: '1',
    receiverId: '2',
    text: 'Thank you so much, Arjun! Your IoT energy management system is amazing too. How did you handle the sensor integration?',
    timestamp: new Date('2024-01-28T11:15:00'),
    read: true
  },
  {
    id: 'm3',
    conversationId: 'c1',
    senderId: '2',
    receiverId: '1',
    text: 'We used MQTT protocol for communication between sensors and the central server. It worked really well for real-time data streaming.',
    timestamp: new Date('2024-01-28T14:20:00'),
    read: true
  },
  {
    id: 'm4',
    conversationId: 'c1',
    senderId: '1',
    receiverId: '2',
    text: 'That\'s a great approach! Would love to discuss more about your project sometime.',
    timestamp: new Date('2024-01-28T15:45:00'),
    read: true
  },
  {
    id: 'm5',
    conversationId: 'c2',
    senderId: '4',
    receiverId: '1',
    text: 'Hey! I noticed you\'re working on AI/ML projects. I\'m building an autonomous robot and could use some help with the computer vision part. Any suggestions?',
    timestamp: new Date('2024-01-30T09:00:00'),
    read: false
  },
  {
    id: 'm6',
    conversationId: 'c3',
    senderId: '3',
    receiverId: '1',
    text: 'Hi Priya! Great job on the waste segregation project. I\'m working on a similar sustainability initiative. Would you be interested in collaborating?',
    timestamp: new Date('2024-01-31T16:30:00'),
    read: false
  },
  {
    id: 'm7',
    conversationId: 'c4',
    senderId: '5',
    receiverId: '1',
    text: 'Hello! I saw we both worked on healthcare tech projects. I\'d love to exchange ideas about NLP implementations.',
    timestamp: new Date('2024-02-01T08:15:00'),
    read: false
  }
];

// Helper function to get conversations for a user
export const getConversationsForUser = (userId: string): Conversation[] => {
  const userMessages = mockMessages.filter(
    m => m.senderId === userId || m.receiverId === userId
  );

  const conversationMap = new Map<string, Message[]>();
  
  userMessages.forEach(message => {
    if (!conversationMap.has(message.conversationId)) {
      conversationMap.set(message.conversationId, []);
    }
    conversationMap.get(message.conversationId)!.push(message);
  });

  const conversations: Conversation[] = [];
  
  conversationMap.forEach((messages, conversationId) => {
    messages.sort((a, b) => b.timestamp.getTime() - a.timestamp.getTime());
    const lastMessage = messages[0];
    const unreadCount = messages.filter(m => m.receiverId === userId && !m.read).length;
    
    const participantIds = [
      ...new Set(messages.flatMap(m => [m.senderId, m.receiverId]))
    ];

    conversations.push({
      id: conversationId,
      participantIds,
      lastMessage,
      unreadCount
    });
  });

  conversations.sort((a, b) => 
    b.lastMessage.timestamp.getTime() - a.lastMessage.timestamp.getTime()
  );

  return conversations;
};

// Helper function to get messages in a conversation
export const getMessagesInConversation = (conversationId: string): Message[] => {
  return mockMessages
    .filter(m => m.conversationId === conversationId)
    .sort((a, b) => a.timestamp.getTime() - b.timestamp.getTime());
};

// Helper function to get conversation between two users
export const getConversationBetweenUsers = (user1Id: string, user2Id: string): string | null => {
  const conversation = mockMessages.find(
    m => (m.senderId === user1Id && m.receiverId === user2Id) ||
         (m.senderId === user2Id && m.receiverId === user1Id)
  );
  return conversation?.conversationId || null;
};

// Helper function to get total unread count
export const getTotalUnreadCount = (userId: string): number => {
  return mockMessages.filter(m => m.receiverId === userId && !m.read).length;
};
