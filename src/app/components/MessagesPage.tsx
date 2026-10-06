import { useState } from 'react';
import { ArrowLeft, Send, MessageCircle } from 'lucide-react';
import { Button } from '@/app/components/ui/button';
import { Input } from '@/app/components/ui/input';
import { Card } from '@/app/components/ui/card';
import { Avatar, AvatarFallback, AvatarImage } from '@/app/components/ui/avatar';
import { ScrollArea } from '@/app/components/ui/scroll-area';
import { Badge } from '@/app/components/ui/badge';
import { 
  getConversationsForUser, 
  getMessagesInConversation,
  getTotalUnreadCount,
  Message 
} from '@/app/data/mockMessages';
import { getUserById, currentUser } from '@/app/data/mockData';

interface MessagesPageProps {
  onBack: () => void;
  onUserClick: (userId: string) => void;
  selectedUserId?: string;
}

export function MessagesPage({ onBack, onUserClick, selectedUserId }: MessagesPageProps) {
  const conversations = getConversationsForUser(currentUser.id);
  
  // Auto-select conversation if selectedUserId is provided
  const initialConversation = selectedUserId 
    ? conversations.find(c => c.participantIds.includes(selectedUserId))
    : conversations[0];
  
  const [selectedConversation, setSelectedConversation] = useState(initialConversation?.id || null);
  const [newMessage, setNewMessage] = useState('');
  const [messages, setMessages] = useState<Message[]>(
    selectedConversation ? getMessagesInConversation(selectedConversation) : []
  );

  const handleSelectConversation = (conversationId: string) => {
    setSelectedConversation(conversationId);
    setMessages(getMessagesInConversation(conversationId));
    setNewMessage('');
  };

  const handleSendMessage = () => {
    if (!newMessage.trim() || !selectedConversation) return;

    const conversation = conversations.find(c => c.id === selectedConversation);
    if (!conversation) return;

    const otherUserId = conversation.participantIds.find(id => id !== currentUser.id);
    if (!otherUserId) return;

    const message: Message = {
      id: `m${Date.now()}`,
      conversationId: selectedConversation,
      senderId: currentUser.id,
      receiverId: otherUserId,
      text: newMessage,
      timestamp: new Date(),
      read: false
    };

    setMessages([...messages, message]);
    setNewMessage('');
  };

  const handleKeyPress = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSendMessage();
    }
  };

  const getOtherUser = (conversation: typeof conversations[0]) => {
    const otherUserId = conversation.participantIds.find(id => id !== currentUser.id);
    return otherUserId ? getUserById(otherUserId) : null;
  };

  const selectedConversationData = conversations.find(c => c.id === selectedConversation);
  const selectedOtherUser = selectedConversationData ? getOtherUser(selectedConversationData) : null;

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white border-b border-gray-200 sticky top-0 z-10 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <Button 
              variant="ghost" 
              onClick={onBack}
              className="flex items-center gap-2 text-gray-600 hover:text-gray-900"
            >
              <ArrowLeft className="size-4" />
              Back to Home
            </Button>
            <h1 className="text-xl text-gray-900">Messages</h1>
            <div className="w-24"></div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-4 py-8">
        <div className="grid lg:grid-cols-3 gap-6 h-[calc(100vh-200px)]">
          {/* Conversations List */}
          <Card className="lg:col-span-1 border-gray-200 flex flex-col">
            <div className="p-4 border-b border-gray-200">
              <h2 className="text-lg text-gray-900">Conversations</h2>
            </div>
            
            <ScrollArea className="flex-1">
              <div className="divide-y divide-gray-200">
                {conversations.length === 0 ? (
                  <div className="p-8 text-center text-gray-500">
                    <MessageCircle className="size-12 mx-auto mb-3 text-gray-300" />
                    <p>No messages yet</p>
                  </div>
                ) : (
                  conversations.map((conversation) => {
                    const otherUser = getOtherUser(conversation);
                    if (!otherUser) return null;

                    return (
                      <button
                        key={conversation.id}
                        onClick={() => handleSelectConversation(conversation.id)}
                        className={`w-full p-4 flex items-start gap-3 hover:bg-gray-50 transition-colors text-left ${
                          selectedConversation === conversation.id ? 'bg-indigo-50' : ''
                        }`}
                      >
                        <Avatar className="size-12 flex-shrink-0">
                          <AvatarImage src={otherUser.avatar} />
                          <AvatarFallback>{otherUser.name.charAt(0)}</AvatarFallback>
                        </Avatar>
                        <div className="flex-1 min-w-0">
                          <div className="flex items-center justify-between mb-1">
                            <p className="text-gray-900 truncate">{otherUser.name}</p>
                            {conversation.unreadCount > 0 && (
                              <Badge className="bg-indigo-600 text-white ml-2">
                                {conversation.unreadCount}
                              </Badge>
                            )}
                          </div>
                          <p className="text-sm text-gray-600 truncate">
                            {conversation.lastMessage.text}
                          </p>
                          <p className="text-xs text-gray-500 mt-1">
                            {conversation.lastMessage.timestamp.toLocaleDateString()}
                          </p>
                        </div>
                      </button>
                    );
                  })
                )}
              </div>
            </ScrollArea>
          </Card>

          {/* Chat View */}
          <Card className="lg:col-span-2 border-gray-200 flex flex-col">
            {selectedConversation && selectedOtherUser ? (
              <>
                {/* Chat Header */}
                <div className="p-4 border-b border-gray-200 flex items-center gap-3">
                  <Avatar className="size-10">
                    <AvatarImage src={selectedOtherUser.avatar} />
                    <AvatarFallback>{selectedOtherUser.name.charAt(0)}</AvatarFallback>
                  </Avatar>
                  <div className="flex-1">
                    <button
                      onClick={() => onUserClick(selectedOtherUser.id)}
                      className="text-gray-900 hover:text-indigo-600"
                    >
                      {selectedOtherUser.name}
                    </button>
                    <p className="text-sm text-gray-600">{selectedOtherUser.college}</p>
                  </div>
                </div>

                {/* Messages */}
                <ScrollArea className="flex-1 p-4">
                  <div className="space-y-4">
                    {messages.map((message) => {
                      const isOwnMessage = message.senderId === currentUser.id;
                      return (
                        <div
                          key={message.id}
                          className={`flex ${isOwnMessage ? 'justify-end' : 'justify-start'}`}
                        >
                          <div
                            className={`max-w-[70%] rounded-lg px-4 py-2 ${
                              isOwnMessage
                                ? 'bg-indigo-600 text-white'
                                : 'bg-gray-100 text-gray-900'
                            }`}
                          >
                            <p className="break-words">{message.text}</p>
                            <p
                              className={`text-xs mt-1 ${
                                isOwnMessage ? 'text-indigo-100' : 'text-gray-500'
                              }`}
                            >
                              {message.timestamp.toLocaleTimeString([], {
                                hour: '2-digit',
                                minute: '2-digit',
                              })}
                            </p>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </ScrollArea>

                {/* Message Input */}
                <div className="p-4 border-t border-gray-200">
                  <div className="flex gap-2">
                    <Input
                      placeholder="Type a message..."
                      value={newMessage}
                      onChange={(e) => setNewMessage(e.target.value)}
                      onKeyPress={handleKeyPress}
                      className="flex-1 border-gray-200"
                    />
                    <Button
                      onClick={handleSendMessage}
                      disabled={!newMessage.trim()}
                      className="bg-indigo-600 hover:bg-indigo-700"
                    >
                      <Send className="size-4" />
                    </Button>
                  </div>
                </div>
              </>
            ) : (
              <div className="flex-1 flex items-center justify-center text-gray-500">
                <div className="text-center">
                  <MessageCircle className="size-16 mx-auto mb-4 text-gray-300" />
                  <p>Select a conversation to start messaging</p>
                </div>
              </div>
            )}
          </Card>
        </div>
      </main>
    </div>
  );
}
